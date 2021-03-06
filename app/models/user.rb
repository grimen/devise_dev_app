class User < ActiveRecord::Base
  
  devise :trackable
  #devise :confirmable
  #devise :timeoutable
  #devise :activatable
  devise :authenticatable
  devise :validatable
  #devise :facebook_connectable
  
  def before_facebook_connect(fb_session)
    fb_session.user.populate(:locale, :current_location, :username, :name,
                                     :first_name, :last_name, :birthday_date, :sex,
                                     :city, :state, :country, :proxied_email)
                                     
    self.confirmation_token = fb_session.user.name # just testing, makes no sense
  end
  
  def after_facebook_connect(fb_session)
    
  end
  
end
