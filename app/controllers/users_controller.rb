class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User has been saved."
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(creator: @user)
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