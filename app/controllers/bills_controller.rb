class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?, :except => [:new, :create, :update]

  def index
    @bills = Bill.all
    
    respond_to do |format|
      format.html
      
      format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"Bills_List_#{DateTime.now.to_date}.csv\""
          headers['Content-Type'] ||= 'text/csv'
      end
      
    end
    
  end

  def show
  end

  def new
    @bill = Bill.new
  end

  def edit
  end

  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      if @bill.save
        format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bill }
      else
        format.html { render action: 'new' }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
        params.require(:bill).permit(:svc_address_1, :svc_address_2, :current_provider, 
            :kwh_usage, :energy_charge, :usage_charge, :esi_id, :meter_number, 
            :account_number, :plan_end_date, :last_bill_amount, :bill_image)
    end
end
