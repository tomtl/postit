class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_editor, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{ |post| post.total_votes }.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post has been created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "This post has been updated."
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

    respond_to do |format| 
      format.html do
        if @vote.valid?
          flash[:notice] = "You're vote has been counted."
        else
          flash[:error] = "You can only vote for that once."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, category_ids: [])
    end

    def set_post
      @post = Post.find_by slug: params[:id]
    end

    def require_editor
      access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
    end
end
