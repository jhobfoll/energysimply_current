class ClickTrackingsController < ApplicationController
  before_action :set_click_tracking, only: [:show, :edit, :update, :destroy]
   before_filter :is_admin?, :except => [:new, :create, :update]
  
  # GET /click_trackings
  # GET /click_trackings.json
  def index
    @click_trackings = ClickTracking.all
  end

  # GET /click_trackings/1
  # GET /click_trackings/1.json
  def show
  end

  # GET /click_trackings/new
  def new
    @click_tracking = ClickTracking.new
  end

  # GET /click_trackings/1/edit
  def edit
  end

  # POST /click_trackings
  # POST /click_trackings.json
  def create
    ClickTracking.create!( zip: (params[:zip]), url: CGI.unescape(params[:url]), user_id: (params[:userid]), ip_address: request.remote_ip )
    redirect_to(URI.decode(params[:url]))

#    @click_tracking = ClickTracking.new(click_tracking_params)

#    respond_to do |format|
#      if @click_tracking.save
#        format.html { redirect_to @click_tracking, notice: 'Click tracking was successfully created.' }
#        format.json { render action: 'show', status: :created, location: @click_tracking }
#      else
#        format.html { render action: 'new' }
#        format.json { render json: @click_tracking.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # PATCH/PUT /click_trackings/1
  # PATCH/PUT /click_trackings/1.json
  def update
    respond_to do |format|
      if @click_tracking.update(click_tracking_params)
        format.html { redirect_to @click_tracking, notice: 'Click tracking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @click_tracking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /click_trackings/1
  # DELETE /click_trackings/1.json
  def destroy
    @click_tracking.destroy
    respond_to do |format|
      format.html { redirect_to click_trackings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_click_tracking
      @click_tracking = ClickTracking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def click_tracking_params
      params.require(:click_tracking).permit(:zip, :url, :user_id)
    end
end
