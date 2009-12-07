class User < ActiveRecord::Base
  #devise :all
  devise :trackable
  devise :facebook_connectable
end
