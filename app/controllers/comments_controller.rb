class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
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
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    if @vote.valid?
      flash[:notice] = "Your vote has been counted."
      redirect_to :back
    else
      flash[:error] = "You can only vote once on that."
      redirect_to post_path(@post)
    end
  end
end
