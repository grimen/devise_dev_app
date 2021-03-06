# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.gem 'formtastic'
  config.gem 'rails-footnotes', :version => '3.6.3'
  config.gem 'warden'#, :version => '0.6.4'
  
  config.gem 'devise'
  config.gem 'facebooker'
  #config.gem 'devise_facebook_connectable'
  
  
  config.plugins = [:devise, :devise_facebook_connectable, :all]
  
  config.time_zone = 'UTC'
  config.i18n.default_locale = :en
  
end
