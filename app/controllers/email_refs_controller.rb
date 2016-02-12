class EmailRefsController < ApplicationController
  before_action :set_email_ref, only: [:show, :edit, :update, :destroy]
  before_filter :is_admin?, :except => [:create_email_ref, :check_email]
  
  def index
    @email_refs = EmailRef.all
  end


  def show
  end


  def new
    @email_ref = EmailRef.new
  end


  def edit
  end


  def create
    @email_ref = EmailRef.new(email_ref_params)

    respond_to do |format|
      if @email_ref.save
        format.html { redirect_to @email_ref, notice: 'Email ref was successfully created.' }
        format.json { render action: 'show', status: :created, location: @email_ref }
      else
        format.html { render action: 'new' }
        format.json { render json: @email_ref.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @email_ref.update(email_ref_params)
        format.html { redirect_to @email_ref, notice: 'Email ref was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @email_ref.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @email_ref.destroy
    respond_to do |format|
      format.html { redirect_to email_refs_url }
      format.json { head :no_content }
    end
  end
  
  
  def check_email

    @refd_email = User.find_by_email(params[:email])
    if @refd_email.blank?
      @refd_email = EmailRef.find_by_email(params[:email])
    end
    
    if @refd_email.present? 
      respond_to do |format|
        format.json { render :json => {'message' => "EmailFound"}, :status => :ok }
      end #do
  
    else
      respond_to do |format|
        format.json { render :json => {'message' => "Not Present"}, :status => :ok }
      end #do
    
    end
    
  end
  
  
  def create_email_ref
    @email_ref = EmailRef.new(email_ref_params)
    @email_ref.ref_date = DateTime.now
    @email_ref.refd_by = current_user

    EmailRef.transaction do #mailer and new record must both happen together

      if @email_ref.save!
        # Send Email Here
        EmailRefMailer.email_ref_greeting(@email_ref, current_user).deliver
        puts "Successful Referral." 
        respond_to do |format|
          format.js
        end #do
      else
        puts "Referral Save-Error." 
        respond_to do |format|
          format.js
        end #do
      end
    end #do transaction
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_ref
      @email_ref = EmailRef.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_ref_params
      params.require(:ref_email).permit(:email)
    end
end
