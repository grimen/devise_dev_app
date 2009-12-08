class User < ActiveRecord::Base
  #devise :all
  devise :trackable
  devise :facebook_connectable
  
  # Overridden in Facebook Connect:able model, e.g. "User".
  #
  def before_facebook_connect(fb_session)
    puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    # Just fetch what we really need from Facebook...
    fb_session.user.populate(:locale, :current_location, :username, :name,
                              :first_name, :last_name, :birthday_date, :sex,
                              :city, :state, :country)
    logger.debug fb_session.user.username.inspect
    # self.locale             = my_fancy_locale_parser(fb_session.user.locale)
    #     "Stockholm" => "(GMT+01:00) Stockholm", "Never-Never-land" => "(GMT+00:00) UTC"
    #     self.time_zone          = fb_session.user.current_location.try(:city)
    #     self.country            = fb_session.user.current_location.try(:country)
    #     
    #     self.username           = fb_session.user.username
    #     
    #     self.profile.real_name  = fb_session.user.name
    #     self.profile.first_name = fb_session.user.first_name
    #     self.profile.last_name  = fb_session.user.last_name
    #     self.profile.birthdate  = fb_session.user.birthday_date.try(:to_date)
    #     self.profile.gender     = my_fancy_gender_parser(fb_session.user.sex)
    #     
    #     self.profile.city       = fb_session.user.hometown_location.try(:city)
    #     self.profile.zip_code   = fb_session.user.hometown_location.try(:state)
    #     self.profile.country    = fb_session.user.hometown_location.try(:country)
    
    # etc...
    
  end
end
