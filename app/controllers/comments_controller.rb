class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:comment][:post_id])
    @post.comments << Comment.new(params[:comment].merge(:user => current_user))
    @post.save
    redirect_to "/read/#{@post.slug}"
  end

  def upvote
    @comment = Comment.find(params[:id])
    @comment.upvote(current_user)
    render :nothing => true
  end
end