# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  # before_filter :halt_if_no_user
  # 
  # def halt_if_no_user
  #   if request.xhr? && !signed_in?(:user) && params[:controller] != 'sessions'
  #     render(:nothing => true, :status => 401) && return
  #   end
  # end
  
  # def authenticate_user!
  #   unless current_user
  #     render :nothing => true, :status => 401 && return if request.xhr?
  #     super
  #   end
  #   super
  # end
  
end
