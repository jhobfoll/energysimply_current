class SessionsController < Devise::SessionsController

  after_filter :after_login, :only => :create
  before_filter :before_sign_out, :only => :destroy

  def after_login
    analytics.track_user_sign_in
  end

  def before_sign_out
    analytics.track_user_sign_out
  end

end
