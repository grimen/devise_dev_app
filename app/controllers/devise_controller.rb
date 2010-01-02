class DeviseController < ApplicationController
  
  include Devise::Controllers::Helpers
  
  before_filter :set_devise_mapping
  
  def sign_in
    render '/sessions/new', :layout => false
  end
  
  def after_sign_in
    respond_to do |format|
      format.js
    end
  end
  
  protected
    
    def is_devise_resource?
      true
    end
    
    def set_devise_mapping
      @devise_mapping = Devise.mappings[params[:scope].to_sym]
    end
    
end