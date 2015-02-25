# comments controller
class CommentsController < ApplicationController
  before_filter :find_news
  def create
    @comment = @newscast.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to newscast_path(@newscast)
    else
      render '/newscasts/show'
    end
  end

  def destroy
    @comment = @newscast.comments.shod(params[:id])
    authorize! :delete, @comment
    @comment.destroy
    flash[:notice] = "Comment deleted successfully"
    redirect_to newscast_path(@newscast)
  end

  private

  def find_news
    @newscast = Newscast.shod(params[:newscast_id])
  end

  def comment_params
    params.require(:comment).permit!
  end
end
