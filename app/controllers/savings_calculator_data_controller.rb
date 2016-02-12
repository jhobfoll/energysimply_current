class SavingsCalculatorDataController < ApplicationController
  #before_action :set_savings_calculator_datum, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?, except: [:savings_calculator, :savings_calculator_calculate]

  # GET /savings_calculator_data
  # GET /savings_calculator_data.json
  def index
    @savings_calculator_data = SavingsCalculatorDatum.all
  end

  # Method for CSV Import of Data
  def import
    SavingsCalculatorDatum.import(params[:file])
    redirect_to savings_calculator_data_path, notice: "New TDU Data Imported Successfully."
  end

  # GET /calculator
  def savings_calculator
puts ">>>>>>>>>> Visitor Record: " + @cached_visitor.inspect
  end

  # POST /calculator
  def savings_calculator_calculate

    # Determine Array Shift so Current Month is at top of table
    day_today = Date.today.strftime("%d").to_i
    month_today = Date.today.strftime("%m").to_i
    @array_shift = ( day_today > 14 ? month_today : month_today - 1 )

    if (params[:calculator_zip]).present?
        @zip_for_calculate = (params[:calculator_zip])
    elsif @zip.present
      @zip_for_calculate = @zip.zip
    end

    @bill_month = (params[:date][:month])
    @bill_mo_cost = (params[:calculator_bill_mo_cost])
    @bill_kwh = (params[:calculator_bill_kwh])

    @calculator_data_savings = true

    # Return all records 12-mo
    # - default cheapest unless radio set to renewable

    unless  ( @zip_for_calculate.present? && @bill_month.present? &&
             @bill_mo_cost.present? && @bill_kwh.present?
            )

      puts ">>>>>>>> Missing Form Fields"
      @calculator_data_savings = false
      @missing_calc_inputs = true
      flash[:notice] = "All Form Fields Are Required.  Please fill and resubmit."
      respond_to do |format|
        format.html { render 'savings_calculator' }
        format.js { render 'savings_calculator' }
      end
      return
    end

    if ( @bill_kwh.to_i < 100 || @bill_kwh.to_i > 10000 )
      @calculator_data_savings = false
      @bad_kwh = true
      flash[:notice] = "KWH Usage out of range."
      respond_to do |format|
        format.html { render 'savings_calculator' }
        format.js { render 'savings_calculator' }
      end
      return
    end

    if ( @bill_mo_cost.to_i < 10 || @bill_mo_cost.to_i > 1000 )
      @calculator_data_savings = false
      @bad_mo_cost = true
      flash[:notice] = "Monthly Cost out of range."
      respond_to do |format|
        format.html { render 'savings_calculator' }
        format.js { render 'savings_calculator' }
      end
      return
    end

    #zip table has "tdu_name" and "zip"
    @zip_record = Zip.where( 'zip = ?', @zip_for_calculate ).first
    if @zip_record.present?
      @tdu_name = @zip_record.tdu_name
      puts ">>>>>>>>>>>>> OUR TDU NAME: " + @tdu_name.inspect
      unless current_user.present?
        @cached_visitor.update_column(:zip_id, @zip_record.id)
      end
      if @tdu_name.downcase.include?('edison')
        @calculator_data_savings = false
        @IL_zip = true
        flash[:notice] = "Illinois Calculator Coming Soon!"
        respond_to do |format|
          format.html { render 'savings_calculator' }
          format.js { render 'savings_calculator' }
        end
        return
      end # IL Zip Check

    else
      puts ">>>>>>>>>>Zip/TDU Not Found"
      @calculator_data_savings = false
      flash[:notice] = "Zip Not Found."
      @bad_zip = true
      respond_to do |format|
        format.html { render 'savings_calculator' }
      end
      return
    end

    if (params[:plan_type]).present? && current_user.blank?
      @cached_visitor.update_column(:plan_type,(params[:plan_type]))
    end

    unless (params[:plan_type]) == "Most Affordable 100% Renewable"
      @relevantPlansForTDU = SavingsCalculatorDatum.
        where('"TduCompanyName" = ?', @tdu_name).
        where('"TermValue" = ?', 12)
    else
      @relevantPlansForTDU = SavingsCalculatorDatum.
        where('"TduCompanyName" = ?', @tdu_name).
        where('"TermValue" = ?', 12).
        where('"Renewable" = ?', 100)
    end


    puts ">>>>>>>>>>>>> OUR TDU Company-Plan Count: " + @relevantPlansForTDU.count.to_s
    # puts "---------------"
    # puts ">>>>>>>>>>>>> OUR TDU Company-Plan Set As JSON: " + @relevantPlansForTDU.to_json

    unless @relevantPlansForTDU.present? && @relevantPlansForTDU.count > 0
      puts ">>>>>>>>>>No Company-Plans for TDU Found"
      @calculator_data_savings = false
      flash[:notice] = "Plans Not Found."
      respond_to do |format|
        format.html { render 'savings_calculator' }
      end
      return
    end

    # BEST PRICE DATA CALCULATION

    # params from form @bill_month, @bill_mo_cost, @bill_kwh
    monthFactors = [ 1, 0.8843, 0.7443, 0.6890, 0.8407, 1.1526, 1.3285, 1.4124, 1.1787, 0.8444, 0.67892, 0.8633 ];
    puts ">>>>>>>>>>> @bill_month is: " + @bill_month.to_s
    puts ">>>>>>>>>>> monthFactors[((@bill_month.to_i)-1)]): " + (monthFactors[((@bill_month.to_i)-1)]).to_s
    constantMonthKWH = (@bill_kwh.to_i / monthFactors[((@bill_month.to_i)-1)]);

    @bestPlan = nil;
    @bestMonthCosts = [];
    best_cost_total = 0;

    @relevantPlansForTDU.each do |current_tdu|
      rate_for_month = 0;
      fixed_rate = 0;
      cost_by_month = [];
      mo_total = 0;
      cost_year = 0;

      (0..11).each do |month|

        mo_usage = constantMonthKWH * monthFactors[month]

        if mo_usage > 1000
          rate_for_month = current_tdu.rate_1000 -
            (current_tdu.rate_1000 - current_tdu.rate_2000) * (mo_usage - 1000) / (2000 - 1000)
        elsif (mo_usage > 500)
          rate_for_month = current_tdu.rate_500 -
            (current_tdu.rate_500 - current_tdu.rate_1000) * (mo_usage - 500) / (1000 - 500)
        else
          rate_for_month = current_tdu.rate_100 -
            (current_tdu.rate_100 - current_tdu.rate_500) * (mo_usage - 100) / (500 - 100 )
        end

        if mo_usage < 1000
          fixed_rate = current_tdu.rate_500_fixed
        elsif mo_usage < 2000
          fixed_rate = current_tdu.rate_1000_fixed
        else
          fixed_rate = current_tdu.rate_2000_fixed
        end

        mo_total = (((mo_usage * rate_for_month.round(4)) + fixed_rate.round(2)).to_f).round(2)
        cost_by_month.push(mo_total)
        cost_year += mo_total;
      end # loop through months

      if cost_year < best_cost_total || @bestPlan == nil
        @bestPlan = current_tdu;
        @bestMonthCosts = cost_by_month
        best_cost_total = cost_year;
        puts ">>>> Best Offer So Far: " + @bestPlan.RepCompany + " - " + @bestPlan.Product +
          " - " + best_cost_total.to_s
      end

    end # loop through Plans

    # find or create customer_usage record for this visitor or user
    if current_user.present?
      @usage_record = CustomerUsage.where('id = ?', current_user.customer_usage_id).first
      unless @usage_record.present?
        if @cached_visitor.present? && @cached_visitor.customer_usage_id.present?
          current_user.update_column(:customer_usage_id, @visitor_record.customer_usage_id)
          @usage_record = CustomerUsage.where('id = ?', @cached_visitor.customer_usage_id).first
        else
          @usage_record = CustomerUsage.new
          @usage_record.save
          current_user.update_column(:customer_usage_id, @usage_record.id)
        end
      end
    else
      @usage_record = CustomerUsage.where('id = ?', @cached_visitor.customer_usage_id).first
      unless @usage_record.present?
        @usage_record = CustomerUsage.new
        @usage_record.save
      end
    end

    # loop through columns on this record and put in the customer_usage table
    i = -1;
    CustomerUsage.columns.each do |c|
      if ( (c.name).to_s.include?("mo_") )
        i +=1;
        @usage_record.update_column( :"#{c.name}", (constantMonthKWH * monthFactors[i]).round(2) )
      end
    end

    respond_to do |format|
      format.html { render 'savings_calculator' }
      format.js { render 'savings_calculator' } # runs on 'remote: true'
    end

  end


  # GET /savings_calculator_data/new
  def new
    @savings_calculator_datum = SavingsCalculatorDatum.new
  end

  # GET /savings_calculator_data/1/edit
  def edit
  end

  # POST /savings_calculator_data
  # POST /savings_calculator_data.json
  def create
    @savings_calculator_datum = SavingsCalculatorDatum.new(savings_calculator_datum_params)

    respond_to do |format|
      if @savings_calculator_datum.save
        format.html { redirect_to @savings_calculator_datum, notice: 'Savings calculator datum was successfully created.' }
        format.json { render action: 'show', status: :created, location: @savings_calculator_datum }
      else
        format.html { render action: 'new' }
        format.json { render json: @savings_calculator_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /savings_calculator_data/1
  # PATCH/PUT /savings_calculator_data/1.json
  def update
    respond_to do |format|
      if @savings_calculator_datum.update(savings_calculator_datum_params)
        format.html { redirect_to @savings_calculator_datum, notice: 'Savings calculator datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @savings_calculator_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /savings_calculator_data/1
  # DELETE /savings_calculator_data/1.json
  def destroy
    @savings_calculator_datum.destroy
    respond_to do |format|
      format.html { redirect_to savings_calculator_data_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_savings_calculator_datum
      @savings_calculator_datum = SavingsCalculatorDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def savings_calculator_datum_params
      params.require(:savings_calculator_datum).permit(:idKey, :TduCompanyName, :RepCompany, :Product, :Renewable, :TermValue, :Promo_adj, :rate_100, :rate_500, :rate_1000, :rate_2000, :rate_500_fixed, :rate_1000_fixed, :rate_2000_fixed)
    end
end
