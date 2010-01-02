ActionController::Routing::Routes.draw do |map|
  
  # map.after_sign_in 'users/after_sign_in.js', :controller => 'users', :action => 'after_sign_in', :format => :js
  # map.connect 'devise/after_sign_in.js', :controller => 'devise', :action => 'after_sign_in', :format => :js
  map.connect 'devise/sign_in/:scope', :controller => 'devise', :action => 'sign_in'
  
  map.user_sign_up 'users/sign_up', :controller => 'users', :action => 'new'
  
  map.devise_for :users, :admin
  
  map.resource :home, :only => :index, :member => {:after_sign_in => :get}, :controller => 'home'
  map.resource :user
  map.resources :admins, :only => [:index]
  
  map.root :controller => :home
  
end
