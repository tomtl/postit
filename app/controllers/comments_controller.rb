class CommentsController < ApplicationController
  before_action :set_post
  before_action :require_user

  def create
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment has been added."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote has been counted."
        else
          flash[:error] = "You can only vote once on that."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

end
