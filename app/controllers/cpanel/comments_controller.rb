class Cpanel::CommentsController < Cpanel::ApplicationController
  def index
    @comments = Comment.all
  end

  def destroy
    @comment = Comment.find(params[:id])

    @comment.destroy

    respond_to do |format|
      format.html { redirect_to cpanel_comments_url }
    end
  end
end