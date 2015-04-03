class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(username: params[:username])
    
    if user && user.authenticate(params[:password])
      session[:user_slug] = user.slug
      flash[:notice] = "Welcome - You're logged in!"
      redirect_to root_path
    else
      flash[:error] = "There is something wrong with your username or password."
      redirect_to login_path
    end
  end
  
  def destroy
    session[:user_slug] = nil
    flash[:notice] = "You've logged out."
    redirect_to root_path
  end
end