class CustomerUsagesController < ApplicationController
  before_action :set_customer_usage, only: [:show, :edit, :update, :destroy]

  # GET /customer_usages
  # GET /customer_usages.json
  def index
    @customer_usages = CustomerUsage.all
  end

  # GET /customer_usages/1
  # GET /customer_usages/1.json
  def show
  end

  # GET /customer_usages/new
  def new
    @customer_usage = CustomerUsage.new
  end

  # GET /customer_usages/1/edit
  def edit
  end

  # POST /customer_usages
  # POST /customer_usages.json
  def create
    @customer_usage = CustomerUsage.new(customer_usage_params)

    respond_to do |format|
      if @customer_usage.save
        format.html { redirect_to @customer_usage, notice: 'Customer usage was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer_usage }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_usages/1
  # PATCH/PUT /customer_usages/1.json
  def update
    respond_to do |format|
      if @customer_usage.update(customer_usage_params)
        format.html { redirect_to @customer_usage, notice: 'Customer usage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer_usage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_usages/1
  # DELETE /customer_usages/1.json
  def destroy
    @customer_usage.destroy
    respond_to do |format|
      format.html { redirect_to customer_usages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer_usage
      @customer_usage = CustomerUsage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_usage_params
      params.require(:customer_usage).permit(:mo_01, :mo_02, :mo_03, :mo_04, :mo_05, :mo_06, :mo_07, :mo_08, :mo_09, :mo_10, :mo_11, :mo_12)
    end
end
