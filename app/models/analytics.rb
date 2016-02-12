class Analytics
  class_attribute :backend
  self.backend = AnalyticsRuby
  attr_accessor :user

  def initialize(user)
    # puts "-----------Model-Analytics - Initialize - user: " + user.inspect
    @user = user
    # puts "------------Analytics-object" + self.inspect
  end

  def sio_user_id
    # only a 'current_user / User' object has a 'visitor_id'
    # so sio_user_id == User.visitor_id
    if user.respond_to?('visitor_id') && user.visitor_id.present?
      user.visitor_id
    else # is a Visitor object, where the ID == sio_user_id
      user.id
    end
  end


  def track_page_load(page_name, page_path, company_name = nil, ga_clientID = nil)
    puts "------------Analytics-track_page_load - user.id >> euid: " +  user.id.to_s + " >> " + sio_user_id.to_s
    puts "------------Analytics-track_page_load - GA_ClientID: " + ga_clientID
    #unless @sio_user_id.blank?
      track(
        {
          user_id: sio_user_id,
          event: page_name,
          properties: {
            page_path: page_path,
            company_name: company_name
          },
          context: {
            'Google Analytics' => {
              clientId: ga_clientID
            }
          }
        }
      )
    #end
  end

  def track_user_sign_up
    puts ">>>>>>>>> Track User Sign Up Called with User Info: " + user.inspect
    identify_sign_up # called re_identify... before, because Visitors were identified
    track(
      {
        user_id: sio_user_id,
        event: 'Sign Up New User',
        properties:{
        createdAt: DateTime.now
        }
      }
    )
  end

  def track_user_sign_in
    identify
    track(
      {
        user_id: sio_user_id,
        event: 'Sign In User'
      }
    )
  end

  def track_user_sign_out
    track(
      {
        user_id: sio_user_id,
        event: 'Sign Out User'
      }
    )
  end


    def track_got_zip(zip)
    #identify
    track(
      {
        user_id: sio_user_id,
        event: "got zip",
        properties: {
          new_zip: zip
        }
      }
    )
  end


  def cpp_zip_clear(zip)
    track(
      {
        user_id: sio_user_id,
        event: 'CPP Zip Clear',
        properties: {
          old_zip: zip
        }
      }
    )
  end

  def alias # called from pages_controller "thank_you" for non-served signups only
    backend.alias(
      {
        previous_id: sio_user_id,
        user_id: sio_user_id
      }
    );
    backend.flush(); # flush the old alias
  end


  private

  def identify_sign_up # was called re_identify... before, because Visitors were identified
    backend.identify(identify_signup_params)
  end

  def identify_signup_params
    {
      user_id: sio_user_id,
      traits: sign_up_traits
    }
  end

  def sign_up_traits
    puts '----------Analytics sign_up_traits hit'
    {
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      phone: user.phone,
      plan_grade: user.plan_grade,
      zip: user.zip.zip
    }
  end

  def identify
    backend.identify(identify_params)
  end

  def identify_params
    {
      user_id: sio_user_id,
      traits: user_traits
    }
  end


  def user_traits
    zip_value = ( user.zip.present? ? user.zip.zip : "" )
    {
      email: user.email,
      zip: zip_value
    }.reject { |key, value| value.blank? }
  end

  def track (options)
    backend.track(options)
  end

end


  # def track_user_creation # This was for visitors, no longer being set at this point.
  #   identify
  #   track(
  #     {
  #       user_id: sio_user_id,
  #       event: 'Create User',
  #       properties: {
  #         zip: user.zip
  #       }
  #     }
  #   )
  # end


    # Now get email from track_user_sign_up
    # def track_got_email(email)
    #   track(
    #     {
    #       user_id: sio_user_id,
    #       event: 'Got Email',
    #       properties:{
    #         email: email
    #       }
    #     }
    #   )
    # end


    #def track_got_zip(zip)
      #identify
      # puts "track_got_zip sio_user_id: " + sio_user_id.to_s + " " +  @sio_user_id.inspect.to_s
      # puts "track_got_zip user object: " + user.inspect.to_s + " " + @user.inspect.to_s
      # track(
      #   {
      #     user_id: sio_user_id,
      #     event: 'Got Zip',
      #     properties:{
      #       zip: zip
      #     }
      #   }
      # )
    #end
