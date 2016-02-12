class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :check_domain, :visitor_check, :served_lp, :sio_id, :track_page

  protect_from_forgery with: :exception
  helper_method :visitor_check


  def after_sign_in_path_for(resource)
    refer_path
  end

  def check_domain
    if Rails.env.production? and request.host.downcase != 'www.energysimp.ly'
      redirect_to request.protocol + 'www.energysimp.ly' + request.fullpath, :status => 301
    end
  end


  def is_admin?
    if current_user.present?
      if current_user.email == "admin@energysimp.ly"
        return true
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end


  def visitor_check
    @track_identify = false
    if current_user.present?
      @track_identify = true
      return
    else
      # Cache the value the first time it's gotten and assign it if non-existent
      unless @cached_visitor.present?
         @cached_visitor = Visitor.find(session[:visitor_id])
         puts "--------AC-visitor-check look-up cached visitor"
        #  @track_identify = true
         # on failure goes to rescue
      end
      # unless @cached_visitor.unique_id.present?
      #   @cached_visitor.update_column(:unique_id, (request.env["rack.request.cookie_hash"]["_simpleelectricity_session"]))
      # end
      puts "--------AC-visitor-check-found - @cached_visitor: " + @cached_visitor.inspect
      return
    end

     rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
       session[:visitor_id] = nil
       puts "--------AC-visitor-check Rescue"
       create_new_visitor
  end

  def create_new_visitor
    @cached_visitor = Visitor.create
    session[:visitor_id] = @cached_visitor.id
    puts "--------AC-visitor-create_NEW_@cached_visitor: " + @cached_visitor.inspect
    # visitor_check
    # @track_identify = true
    # analytics.track_user_creation
  end

  def reset_visitor
    #puts "--------AC-reset visitor called"
    @cached_visitor.destroy # clears record from db
    @cached_visitor = nil # clears instance of active record in instance-variable
    puts "--------AC-reset visitor post-destroy: " + @cached_visitor.inspect
    visitor_check
    puts "--------AC-reset visitor post-recreate: " + @cached_visitor.inspect
  end


  def zip_lookup(zip)  # Sets from Zip Form Submissions and sets @zip
    #puts "-------AC_zip_lookup begin"
    @zip = nil
    @zip = Zip.where('zip = ?', zip).first if zip.present?
    if @zip.present?
      @cached_visitor.update_attribute(:zip_id, @zip.id)
      analytics.track_got_zip(@zip.zip)
    end
    puts "-------AC_zip_lookup returned: " + @zip.inspect
  end

  def zip_get
    @zip = nil
    if current_user.present?
      @zip = current_user.zip
    elsif @cached_visitor.present?
      @zip = @cached_visitor.zip
    end
    puts "--------AC_zip_get returned: " + @zip.inspect
  end


  def served_lp
    @served_lp = [ "3", "11" ]
    # 11 for TX, 3 for IL
  end

  def extract_company_name(url_path)
    co_path = (url_path).gsub( /\/compare-power-plans\//, '' )
    return ( (co_path).gsub( /-/, ' ' ) )
  end


  def generate_random_password
    range = [*'2'..'9',*'A'..'Z',*'a'..'z']
    value = ( (0...8).map{ range.sample }.join )
    puts "------------Generated Password: " + value
    @plain_pass = value
  end


# //////////////////
# SEGMENT IO

  def analytics
    #puts "----------------AC - Analytics - sio_user: " + sio_user.inspect
    @analytics ||= Analytics.new(sio_user)
    # puts "-----------AC-analytics @analytics set to: " + @analytics.inspect.to_s
    # return @analytics
  end

  def sio_user
    if current_user.present?
      current_user
    elsif @cached_visitor.present?
      @cached_visitor
    else
      visitor_check
      @cached_visitor
    end
  end

  def sio_id
    if current_user.present?
      @sio_userID = current_user.visitor_id
    elsif @cached_visitor.present?  
      @sio_userID = @cached_visitor.id  
    end
  end

  def tracked_pages
    # page_key => page_name
    HashWithIndifferentAccess.new(
      {
        'registrations#new' => 'Registration Page',
        'users#payment' => 'Payment Page',
        'users#submit_bill' => 'Submit Bill Page',
        'pages#thankyou' => 'Thank You Page',
        'compare_power_plans#compare_power_plans' => 'Compare Power Plans Page',
        'compare_power_plans#review' => 'Review Power Plans',
        'pages#home' => 'Home Page',
        'pages#about_energy_simply' => 'About Page',
        'pages#our_mission' => 'Mission Page',
        'pages#tx_plans' => 'Home Page',
        'pages#texas_plans' => 'Home Page',
        'pages#cheapest_electric' => 'Home Page',
        'pages#cheap_plans' => 'Home Page',
        'pages#power_to_choose' => 'Home Page',
        'pages#electric_companies' => 'Home Page',
        'pages#how_it_works' => 'How It Works Page',
        'savings_calculator_data#savings_calculator' => 'Savings Calculator',
        'users#refer' => 'Refer A Friend',
        'pages#energy_simply_team' => 'Team Page',
        'pages#benefits_and_testimonials' => 'Testimonials Page'
      }
    )
  end


  def track_page
    zip_get
    @track = false
    @track_page_company = ''
    page_path = URI.parse(request.fullpath).path
    controller = params[:controller]
    action = params[:action]
    page_key = controller+"#"+action
    puts "---------page_key is: " + page_key
    company_name = nil
    if tracked_pages.has_key?(page_key)
      if page_key == 'compare_power_plans#review'
        @track_page_company = extract_company_name(page_path)
        #puts "---------Company Name is: " + company_name
        # analytics.track_page_load(tracked_pages[page_key], page_path, company_name, ga_clientID)
      end
      puts "---------Tracked Page Name is: " + tracked_pages[page_key]
      @track = true
      @track_page_name = tracked_pages[page_key]
      @track_page_detail = "More Page Details Can Go Here"
    end
  end

  def ga_clientID
        google_analytics_cookie.gsub(/^GA\d\.\d\./, '')
  end

  def google_analytics_cookie
    cookies['_ga'] || ''
  end

# END SEGMENT IO
# ///////////////////

  private

  def authenticate_user!
    store_origin_path
    super
  end

  def store_origin_path
    session[:origin_path] = thank_you_path
  end

  def clear_origin_path
    session[:origin_path] = nil
  end

  def create_visitor
    v = Visitor.create()
    v.save!()
    session[:visitor_id] = v.id
    v
  end


  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_up) do |u|
  	  u.permit(:first_name, :last_name, :email, :address_1, :address_2, :phone, :zip_id,
  	           :service_type, :middle_initial, :maiden_name, :service_type, :plan_type,
  	           :dwelling_type, :svc_new_old, :move_in_date, :meter_type, :rewired, :mobile,
  	           :home_new_old, :sq_ft_range, :pref_plan_type, :dob, :encrypted_ssnum,
               :ssnum, :plan_grade, :referral_key, :password, :password_confirmation)
  	end
  	devise_parameter_sanitizer.for(:account_update) do |u|
  	  u.permit(:first_name, :last_name, :email, :address_1, :address_2, :phone, :zip_id,
               :service_type, :middle_initial, :maiden_name, :service_type, :plan_type,
               :dwelling_type, :svc_new_old, :move_in_date, :meter_type, :rewired, :mobile,
               :home_new_old, :sq_ft_range, :pref_plan_type, :dob, :encrypted_ssnum,
               :ssnum, :plan_grade, :password, :password_confirmation)
  	end
  end
end
