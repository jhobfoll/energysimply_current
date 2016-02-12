class PagesController < ApplicationController

  def home
    if current_user.present?
      @paid_trans = Transaction.where('user_id = ?', current_user.id).
                                where('trans_type != ?',"Failed").
                                first
      if current_user.plan_grade.present? && @paid_trans.blank?
        redirect_to payment_path(:revisit => true)
      else
        redirect_to refer_path
      end
    end
    # see if was referred, lookup the id of referrer, and save to visitor
    if (params[:referral_key]).present?
      puts "-----------Referral Key Detected: " + (params[:referral_key])
      referred_by = User.where( 'referral_key = ?', (params[:referral_key]) ).first
      if referred_by.present?
        puts "-----------Found Referrer ID: " + referred_by.id.to_s
        @cached_visitor.update_column( :referred_by_id, referred_by.id )
      end
    end
    #TODO If user is logged-in admin - to admin-home
    #TODO If user is logged-in non-admin - to customer-home
  end

  def sitemap
  end

  def home_zip_submission # from home-page

    if current_user.present?
      puts "-----ZipSubmit current_user " + current_user.inspect
      sign_out(current_user)
      redirect_to root_path
      return
    end

    zip_lookup(params[:zip]) # sets zip for @cached_visitor if not yet set & sets @zip
    puts "-----ZipSubmit @zip is: " + @zip.inspect

    if @zip.blank?
       flash[:notice] = "Zip Not Found"
       redirect_to root_path
       return
    else
      redirect_to new_user_registration_path(:plan_grade => 'gold')
    end

  end


  def thankyou
    puts "----------ThankYou - current_user.zip.landing_page: " + current_user.zip.landing_page.to_s
    puts "----------ThankYou - Reading @served_lp: " + @served_lp.inspect

    @ref_link = "http://energysimp.ly/" + current_user.referral_key  if (current_user.present? && current_user.referral_key.present?)

    if ( #Served Choice
          ( @served_lp.include?(current_user.zip.landing_page) ) &&
          ( (current_user.zip.tdu_id).present? ) && (current_user.zip.tdu_id > 0)
         )
        @blurb = 'Choice'
        puts "----------Pages Controller - Thank You - Served Choice"
        # Lookup Cost-Savings Data for page
        @tdu = Tdu.where('id = ?', current_user.zip.tdu_id).first

        # analytics.track_user_sign_up # called for served users in users#submit_bill

    elsif ( # Choice Not Served
              ( @served_lp.exclude?(current_user.zip.landing_page) ) &&
              (current_user.zip.landing_page != '0')
          )
         @blurb = 'Non_Served_Choice'
         puts "----------Pages Controller - Thank You - Not Served Choice"
         analytics.alias
         analytics.track_user_sign_up

    else # No Choice
         @blurb = 'No_Choice'
         puts "----------Pages Controller - Thank You - No Choice"
         analytics.alias
         analytics.track_user_sign_up

    end # if/else

  end


  def about_energy_simply
  end

  def jobs
  end

  def how_it_works
  end

  def locations
  end

  def save_energy_and_money_store
  end

  def our_mission
  end

  def cheapest_electric
  end

  def texas_plans
  end

  def tx_plans
  end

  def cheap_plans
  end

  def power_to_choose
    @co_logo_images = Dir.glob("app/assets/images/img/com_logo/*.png")
    puts ">>>>>>LOGOS LIST: " + @co_logo_images.inspect
  end

  def electric_companies
  end

  def renewable_power
  end

  def energy_simply_team
  end

  def terms_of_use
  end

  def benefits_and_testimonials
  end

  def contact_us
    # need
  end

  def contact_us_submit
    # Save Data to Visitor Record
    f_name = (params[:name]).split(" ").first
    l_name = (params[:name]).split(" ").last

    if @cached_visitor.present?
      if f_name.present?
        @cached_visitor.update_attribute(:first_name, f_name)
      end
      if l_name.present?
        @cached_visitor.update_attribute(:last_name, l_name)
      end
      if (params[:email]).present?
        @cached_visitor.update_attribute(:email, (params[:email]))
      end
      # if (params[:phone]).present?
      #   @cached_visitor.update_attribute(:mobile, (params[:phone]))
      # end
      # if we got zip and haven't saved it yet, this will save it.
      zip_lookup(params[:zip])

    end # else is logged-in user

    # Send out mail
    NewCustomerNotificationMailer.contact_us_notification(
      f_name, l_name, (params[:email]), (params[:question])
    ).deliver

  end

end


# def email_submission
#   if current_user.present?
#     puts "-----HomeEmailSubmit current_user " + current_user.inspect
#     sign_out(current_user)
#     redirect_to root_path
#     return
#   end
#
#   # Note: nil integer value for tdu_id is being returned by lookup as zero
#   unless (params[:email]).blank?
#     @cached_visitor.update_column(:email, (params[:email]) )
#   end
#
#   puts "-----HomePhoneSubmit Email is: " + (params[:email])
#   redirect_to new_user_registration_path(:plan_grade => 'gold')
#
#   analytics.track_got_email(params[:email])
# end
