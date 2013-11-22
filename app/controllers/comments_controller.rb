# coding: utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project
  # load_and_authorize_resource

  # xhr POST
  def create
    @comment = Comment.new(params[:comment])
    @comment.project_id = @project.id
    @comment.user_id = current_user.id

    respond_to do |format|
      begin
        @comment.save
        # do something?
        @msg = "评论成功！"
      rescue => e
        @msg = e.full_messages.join("<br />")
      end
      format.html { redirect_to project_url(@project), notice: @msg }
    end
  end

  def delete # by admin
  end

  protected

  def find_project
    @project = Project.find(params[:project_id])
  end
end
