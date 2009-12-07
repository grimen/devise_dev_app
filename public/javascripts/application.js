// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function fb_connect_login() {
  document.getElementById('fb_connect_login_form').submit();
  return false;
};

function fb_connect_custom_login() {
  FB.Connect.requireSession(fb_connect_login);
  return false;
};

function fb_connect_logout() {
  document.getElementById('fb_connect_logout_form').submit();
  return false;
};

function fb_connect_custom_logout() {
  FB.Connect.logout(fb_connect_logout);
  return false;
};