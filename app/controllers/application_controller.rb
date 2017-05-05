class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  #setting the require_login filter here applies it to all controllers that inherit from ApplicationController. 
  #if we want to bypass the filter somewhere, we skip it on the child controller
  before_filter :require_login
  
  private
  
  #a filter to require users to be logged in
  def require_login
    unless current_user
      redirect_to login_url
    end
  end
  
  #a filter for requiring a user to be an admin
  def require_admin
    unless current_user.is_admin
      redirect_to courses_url
    end
  end
  
  #a filter for requiring a user to be either an admin or a registrar type
  def require_admin_registrar
    unless current_user.is_admin || current_user.is_registrar
      redirect_to courses_url
    end
  end
  
end
