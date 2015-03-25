class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User has been saved."
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "Your information has been updated"
      redirect_to :root_path
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :password, :phone, :time_zone)
    end
end