# coding: utf-8
class Cpanel::ProjectsController < Cpanel::ApplicationController
  def index
    @projects = Project.all
  end

  def volunteers
    @project = Project.find(params[:id])
  end

  def publish # GET
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.publish!
      format.html { redirect_to cpanel_projects_url, notice: '发布成功!' }
    rescue => e
      format.html { render action: "index" }
    end
    end
  end

  def unpublish # GET
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.unpublish!
      format.html { redirect_to cpanel_projects_url, notice: '取消发布成功!' }
    rescue => e
      format.html { render action: "index" }
    end
    end
  end
end