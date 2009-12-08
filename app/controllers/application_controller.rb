# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  #before_filter :set_facebook_session
  
  # rescue_from ::Facebooker::Session::SessionExpired, :with => :facebook_session_expired
  
  # def facebook_session_expired
  #     clear_fb_cookies!
  #     clear_facebook_session_information
  #     redirect_to root_url
  #   end
  
end
