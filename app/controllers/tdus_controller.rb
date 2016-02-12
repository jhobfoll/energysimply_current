class TdusController < ApplicationController
  before_action :set_tdu, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?
  
  # GET /tdus
  # GET /tdus.json
  def index
    @tdus = Tdu.all
  end

  # GET /tdus/1
  # GET /tdus/1.json
  def show
  end

  # GET /tdus/new
  def new
    @tdu = Tdu.new
  end

  # GET /tdus/1/edit
  def edit
  end

  # POST /tdus
  # POST /tdus.json
  def create
    @tdu = Tdu.new(tdu_params)

    respond_to do |format|
      if @tdu.save
        format.html { redirect_to @tdu, notice: 'Tdu was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tdu }
      else
        format.html { render action: 'new' }
        format.json { render json: @tdu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tdus/1
  # PATCH/PUT /tdus/1.json
  def update
    respond_to do |format|
      if @tdu.update(tdu_params)
        format.html { redirect_to @tdu, notice: 'Tdu was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tdu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tdus/1
  # DELETE /tdus/1.json
  def destroy
    @tdu.destroy
    respond_to do |format|
      format.html { redirect_to tdus_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tdu
      @tdu = Tdu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tdu_params
      params.require(:tdu).permit(:name, :apt_avg, :apt_best, :house_avg, :house_best)
    end
end
