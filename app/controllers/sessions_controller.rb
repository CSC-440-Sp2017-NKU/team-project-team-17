class SessionsController < ApplicationController
    def new
    end

  def create
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
  end
end
