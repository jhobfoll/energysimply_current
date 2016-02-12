class RegistrationsController < Devise::RegistrationsController

  def new
    resource = build_resource({})

    zip_get # sets @zip


    # assign "sign_up_type" to @cached_visitor in case of form-error re-render
    if @zip.blank?
        @cached_visitor.update_attribute(:sign_up_type, "choice_served")

    elsif ( @served_lp.include?(@zip.landing_page) && @zip.tdu_id.present? && (@zip.tdu_id > 0) ) # missing tdu_id was returning as zero
        #Choice-Served
        @cached_visitor.update_attribute(:sign_up_type, "choice_served")
        @tdu = Tdu.where('id = ?', @cached_visitor.zip.tdu_id).first

    elsif ( @zip.landing_page != '0' && (@zip.tdu_name != 'No choice') )
         # Choice But Not Served
         @cached_visitor.update_attribute(:sign_up_type, "choice_not_served")

    else # No Choice
         @cached_visitor.update_attribute(:sign_up_type, "no_choice")
    end # if/else

    respond_with self.resource

    # Lookup Cost-Savings Data for page
    # @tdu = Tdu.where('id = ?', @zip.tdu_id).first
    # Not Currently Displayed Here

  end #def


def create

      if (params[:zip]).present? # Just got zip now from sign_up form
          zip_lookup(params[:zip]) # instantiates @zip
      else
        zip_get # instantiates @zip and updates Visitor
      end

      # See if this is a new admin-referred user who already exists w/o a password set
      @admin_ref_user = User.where('email = ?', params[:user][:email]).first
      # puts ">>>>>>>>>>" + @admin_ref_user.inspect
      if @admin_ref_user.present? && @admin_ref_user.encrypted_password.blank?

        @admin_ref_user.update(sign_up_params)
          # or @admin_ref_user.update(params[:user])
          # one of those should work like ....
      # update_attributes(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name] ... etc)

        @admin_ref_user.update_column(:zip_id, @zip.id)
        @admin_ref_user.update_column(:visitor_id, @cached_visitor.id)
        sio_user # transfer the way the AnalyticsID is found from Visitor to User

        sign_in(@admin_ref_user, :bypass => true)

        flash[:notice] = "Please Set Your Password."
        redirect_to edit_user_path(@admin_ref_user.id)

        return
      end # if new admin-referred user


      build_resource(sign_up_params)

      # Add plan_grade to new user and save to visitor in case of form-error
      if (params[:user][:plan_grade]).present?
        resource.plan_grade = (params[:user][:plan_grade])
        @cached_visitor.update_column( :plan_grade, (params[:user][:plan_grade]) )
      else
        resource.plan_grade = @cached_visitor.plan_grade if @cached_visitor.plan_grade.present?
      end

      # See if was referred by someone
      if  @cached_visitor.referred_by_id.present?
        puts "-----------Referrer ID from Visitor-: " + @cached_visitor.referred_by_id.to_s
        resource.referred_by_id = @cached_visitor.referred_by_id
      end

      if @zip.blank?
        flash[:notice] = "That Zip Code Was Not Found."
        render :new
        return
      end

      # Create this user's referral key
      resource.referral_key = generate_random_unique_referral_key # method below
      puts "------------RegCntlr - Ref-Key Rcvd: " + resource.referral_key.to_s

      resource.zip_id = @zip.id
      puts "--------RegC - zip_id is: " + resource.zip_id.to_s

      if ( @cached_visitor.sign_up_type == "choice_served" )
        puts "--------RegC - Served User about to save"
        save_success = resource.save
      else # 'no_choice' or 'not_served_choice'
        puts "--------RegC - Not Served User about to save"
        save_success = resource.save(:validate => false)
        # not requiring model-validations on these users
      end

      if resource.customer_usage_id.present?
       resource.customer_usage_id = @cached_visitor.customer_usage_id
      end

      puts "--------RegC - pre-save - resource: " + resource.inspect.to_s

      unless save_success
        @cached_visitor.save!
        puts "--------RegC - Save Error: " + resource.errors.full_messages.to_sentence
        flash[:error] = resource.errors.full_messages.to_sentence
        clean_up_passwords resource
        respond_with resource
        return
      end

      puts "--------RegC - save success"
      yield resource if block_given?
      if resource.active_for_authentication?
        # set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        puts "--------RegC - save success - current_user: " + current_user.inspect.to_s
        # No longer called because not deleting visitors
        # reset_visitor

        # assign Visitor reference to User
        resource.update_column(:visitor_id, @cached_visitor.id)

        # Create Analytics Alias and track event
        # methods in AppCntlr - will set to new 'current_user' - ID will not change
        sio_user # transfer the way the AnalyticsID is found from Visitor to User
        @analytics = nil
        # analytics.track_user_sign_up # moved to thank_you page
      end

      if ( @served_lp.include?(@zip.landing_page) && @zip.tdu_id.present? && (@zip.tdu_id > 0) )
        @user = current_user
        NewCustomerNotificationMailer.new_customer_notification(@user).deliver

        redirect_to payment_path

      # w/Choice Not Served Gave us their email
      elsif ( @zip.landing_page != '0' && (@zip.tdu_name != 'No choice') && (params[:email]).present? )

        # generate a password to send in email
        generate_random_password # method in application controller
        resource.password = @plain_pass
        resource.password_confirmation = @plain_pass
        resource.save!

        NewCustomerMailer.new_customer_signup_greeting_not_yet_served(resource, @plain_pass).deliver
        redirect_to refer_path

      else
        # no mail sent to 'no-choice' folks
        redirect_to refer_path

      end

  end #create



  def generate_random_unique_referral_key
    not_unique = true
    range = [*'0'..'9',*'A'..'Z',*'a'..'z']
    while not_unique.present?
      value = ( "Z" + ( (0...4).map{ range.sample }.join ) )
      not_unique = User.where('referral_key = ?', value).first
    end
    puts "------------Generated Ref-Key: " + value
    return value
  end

end #class
