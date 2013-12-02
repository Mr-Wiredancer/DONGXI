# coding: utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project
  # load_and_authorize_resource

  def create # POST
    comment_params = params[:comment].merge({
      project_id: @project.id,
      user_id: current_user.id
    })
    @comment = Comment.new(comment_params)
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

  def delete # TODO: by admin
  end

  protected

  def find_project
    @project = Project.find(params[:project_id])
  end
end
