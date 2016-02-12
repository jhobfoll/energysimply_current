class UsersController < ApplicationController

  before_filter :is_admin?, :only => [:index, :show, :destroy]


  def index #/admin/users/
    @users = User.order('created_at DESC')

    # @cards_to_export_to_file.find_each do |record|
        # csv_string << (record.id.to_s + ", " + record.card_number.to_s + "\n")
    # end

    respond_to do |format|
      format.html # index.html.erb under /views/users/

      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"Users_List_#{DateTime.now.to_date}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end

      format.json { render :json => @users }
    end #do
  end # def index


  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])

    ## Remove Blank Fields for index-unique fields so AR doesn't try to put in an empty-string in place of null
    # is email present?
    params[:user].delete(:email) if (params[:user][:email]).blank?
    # is phone present?
    params[:user].delete(:phone) if (params[:user][:phone]).blank?

    # add params to @user without saving
    #@user.assign_attributes(params[:user])

    @user.assign_attributes(params.require(:user).permit(:email, :service_type,
            :plan_type, :first_name, :middle_initial, :last_name, :maiden_name,
            :phone, :billing_address_1, :billing_address_2, :dwelling_type,
            :sq_ft_range, :svc_new_old, :move_in_date, :home_new_old, :meter_type,
            :rewired, :mobile, :ssnum, :dob, :zip_id, :password, :password_confirmation))

    if @user.save
      sign_out(current_user) # this and next step necessary to keep Devise from auto-signing out user by default.
      sign_in(@user, current_user, :bypass => true)
      flash[:notice] = "Successfully updated User."
      if current_user && current_user.admin == true
        redirect_to users_path
      else
        redirect_to root_path
      end
    else
      flash[:notice] = "User-Save Failed."
      render :action => 'edit'
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroy
      flash[:notice] = "User deleted."
      redirect_to users_path
    end
  end


  def choose_plan
    zip_get
    # Lookup Cost-Savings Data for page
    @tdu = Tdu.where('id = ?', @zip.tdu_id).first
    puts "---------UC-ChoosePlan - @zip.TDU: " + @zip.tdu_id.to_s
    puts "---------UC-ChoosePlan - @tdu: " + @tdu.inspect
  end

  def choose_plan_update
    # Accepts Plan Submits from Home or Plan Page, saves data,
    # redirects to Registrations-New
    @cached_visitor.update_attribute(:plan_grade, (params[:plan_grade]))
    redirect_to new_user_registration_path
   end


  def payment
    unless (params[:revisit]).present?
      puts "------>>> Payment Controller - params revisit is NOT present"
      @new_sign_up = true # set alias in analytics.js to run if 1st time on this page
    else
      @new_sign_up = false
    end
    #@user = User.find(current_user.id)
    #paypal button re-routes to either:
      # the bill-submission form on success
      # back here on failure
  end


  def submit_bill
    @user = current_user
    @bill = Bill.where('user_id = ?', current_user.id).first
    if @bill.blank?
        @bill = @user.bills.build
    end

    # generate a password to send in email
    generate_random_password # method in application controller
    puts ">>>>>>>>>>Plain Pass in users controller: " + @plain_pass
    @user.password = @plain_pass
    @user.password_confirmation = @plain_pass
    @user.save!
    sign_in(@user, :bypass => true)


    if @user.plan_grade == 'gold'
      NewCustomerMailer.new_customer_signup_greeting_gold(@user, @plain_pass).deliver
    else # Basic Version
      NewCustomerMailer.new_customer_signup_greeting_basic(@user, @plain_pass).deliver
    end
    # analytics.alias
    analytics.track_user_sign_up # called here, after analytics.js 'alias' was triggered in 'payment' method
  end


  def submit_bill_update
    @user = current_user
    @user.update(user_params)

    if (params[:bill]).present?
      @first_bill = Bill.where('user_id = ?', current_user.id).first

      if @first_bill.present?
        @first_bill.update(bill_params)
      else
        @first_bill = Bill.new(:user_id => current_user.id)
        @first_bill.update(bill_params)
      end
    end

    redirect_to refer_path
  end

  def refer
    @ref_link = "https://energysimp.ly/" + current_user.referral_key  if (current_user.present? && current_user.referral_key.present?)
    @user = current_user
    email = cookies[:h_email]

    @bodyId = 'refer'

    @referrals_count = 0

    # find all referred by this user
    @referred = User.where('referred_by_id = ?', current_user.id)

    # try to find a transaction where each referred user has paid
    @referred.each do |referred_user|
        @paid_trans = Transaction.where('user_id = ?', referred_user.id).
                                where('trans_type != ?',"Failed").
                                first
        @referrals_count += 1 if @paid_trans.present?
    end
    puts "Count of Paid Referred Is: " + @count.to_s

        @prize_array = [
        { :name => "Philips LED Bulb", :html => "http://www.amazon.com/gp/product/B00I134ORI/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00I134ORI&linkCode=as2&tag=energyly-20&linkId=RBMSLPSCZANYIQIH", :image => "/assets/philips_slim_led_light.jpg", :qualf_level => "1" },
        { :name => "Kill-a-Watt Usage Monitor", :html => "http://www.amazon.com/gp/product/B00009MDBU/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00009MDBU&linkCode=as2&tag=energyly-20&linkId=SYLGGGC63RJ4YUQ6", :image => "/assets/kill-a-watt_usage_monitor.jpg", :qualf_level => "3" },
        { :name => "WeMo Insight Switch", :html => "http://www.amazon.com/gp/product/B00EOEDJ9W/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00EOEDJ9W&linkCode=as2&tag=energyly-20&linkId=TK64H4NSOTHARQH7", :image => "/assets/wemo_insight_switch.jpg", :qualf_level => "7" },
        { :name => "WeMo LED Starter Set", :html => "http://www.amazon.com/gp/product/B00MMLTUG0/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00MMLTUG0&linkCode=as2&tag=energyly-20&linkId=R7U7WGZUQD7IEWON", :image => "/assets/wemo_led_starter_set.jpg", :qualf_level => "12" },
        { :name => "Nest Learning Thermostat", :html => "http://www.amazon.com/gp/product/B009GDHYPQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B009GDHYPQ&linkCode=as2&tag=energyly-20&linkId=PNWGWS73M5XW4XAL", :image => "/assets/nest_learning_thermostat.jpg", :qualf_level => "25" }
      ]

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :service_type, :plan_type, :first_name, :middle_initial,
                                    :last_name, :maiden_name, :phone, :billing_address_1, :billing_address_2,
                                    :dwelling_type, :sq_ft_range, :svc_new_old, :move_in_date, :home_new_old,
                                    :meter_type, :rewired, :mobile, :ssnum, :dob, :zip_id, :plan_grade,
                                    :bill_send_method, :smart_meter_auth, :password, :password_confirmation)

    end

    def bill_params
        params.require(:bill).permit(:svc_address_1, :svc_address_2, :current_provider,
                                   :kwh_usage, :energy_charge, :usage_charge, :esi_id,
                                   :meter_number, :account_number, :plan_end_date, :last_bill_amount,
                                   :bill_image)
    end

end #class

 # OLD Choose Plan ...
    # they are logged-in and signed-up at this point
    # Not Anymore

#      if (
#             ( (params[:elec_choice_value]) == '11') &&
#             (params[:tdu_id].present? ) # now more specific than SanAnt/Dallas
#         ) #TX Choice
#        @blurb = 'TX_Choice'



#        # Create Bill model-object for our partial-form
#        @first_bill = Bill.new

#      elsif ( ((params[:elec_choice_value]) != '11') && ((params[:elec_choice_value]) != '0') ) # Choice Not TX
#         @blurb = 'Non_TX_Choice'
#
#      else # No Choice
#         @blurb = 'No_Choice'

#      end # if/else

      #super # called automatically, but to clarify what is happening ...

  # end #def
  #  @user = User.find(current_user.id)
  #  @bill = Bill.where('user_id = ?', current_user.id)
   # if @bill.blank?
    #    @bill = @user.bills.build
  #  end
 # end

#
#  def choose_plan_update
#    @zip_selected = Zip.where( 'id = ?', (params[:zip_id]) ).first
#     puts "----------zip record is: " + @zip_selected.inspect
#
#    #@user = User.find(current_user.id)
#    ## save the new info
#    #unless @user.update(user_params)
#     # puts "-----Error Saving User from 1st Page Entry"
#      # TODO need to fix this - will loose the values this way
#     # render :action => 'first_page_sign_up'
#    #  return
#   # end
#    # Now Save bill as the User record is saved, and an ID has been assigned to the new row
#    #@first_bill = Bill.new # params for bill removed from this page in Wireframes 1.5
#    #@first_bill.user_id = current_user.id
#    #@first_bill.save
#    # => redirect_to submit_bill_path
#    redirect_to new_user_registration_path(
#                              :elec_choice_value => (params[:elec_choice_value]),
#                              :zip_id => (params[:zip_id]),
#                              :city => (params[:city]),
#                              :tdu_id => (params[:tdu_id]),
#                              :service_type => (params[:service_type]),
#                              :plan_type => (params[:plan_type]) )
#  end
