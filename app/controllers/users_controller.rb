class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:notice] = "User has been saved."
      session[:user_slug] = @user.slug
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @posts = Post.where(creator: @user)
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile has been updated"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:username, :password, :time_zone)
    end
    
    def set_user
      @user = User.find_by slug: params[:id]
    end
    
    def require_same_user
      if current_user != @user
        flash[:error] = "You're not allowed to do that."
        redirect_to root_path
      end
    end
end