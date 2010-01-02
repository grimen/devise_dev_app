class SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  before_filter :require_no_authentication, :only => [ :new, :create ]

  # GET /resource/sign_in
  def new
    Devise::FLASH_MESSAGES.each do |message|
      set_now_flash_message :failure, message if params.try(:[], message) == "true"
    end
    build_resource
    # render_with_scope :new, :layout => !request.xhr?  # :layout is an ignored param for #render_with_scope
    render :layout => !request.xhr?
  end

  # POST /resource/sign_in
  def create
    if authenticate(resource_name)
      set_flash_message :success, :signed_in
      if request.xhr?
        render :text => flash[:success]
      else
        sign_in_and_redirect(resource_name)
      end
    else
      set_now_flash_message :failure, warden.message || :invalid
      if request.xhr?
        render :text => field_error("Error", flash[:failure]), :status => 406
        # render :new, :layout => false, :status => 406   # testing
      else
        build_resource
        render_with_scope :new
      end
    end
  end

  # GET /resource/sign_out
  def destroy
    set_flash_message :success, :signed_out if signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
  end

  # TODO: Fix this, use Rails field_error_proc
  #
  def field_error(title, text)
    %{<div id="errorExplanation" class="errorExplanation">
                                  <h2>#{title}</h2>
                                  <p>#{text}</p>
                                  </div>}
  end
  
end
