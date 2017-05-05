class SessionsController < ApplicationController
    
    #we skip the login filter, because this is a the login page, and we need logged out users to be able to access it
    skip_before_filter :require_login

  def new
  end

  def create
    #if the email exists in the users table, log the user in, otherwise flash invalid email
    user = User.find_by(email: params[:session][:email].downcase)
    if user
      log_in user
      redirect_to courses_path 
    else
      flash[:danger] = 'Invalid Email'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_url
  end
end
