class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :require_login
  
  private

  def require_login
    unless current_user
      redirect_to login_url
    end
  end
  
  def require_admin
    unless current_user.is_admin
      redirect_to courses_url
    end
  end
  
  def require_admin_registrar
    unless current_user.is_admin || current_user.is_registrar
      redirect_to courses_url
    end
  end
  
end
