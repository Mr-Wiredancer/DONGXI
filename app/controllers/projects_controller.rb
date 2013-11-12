# coding: utf-8
class ProjectsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  load_and_authorize_resource

  include ApplicationHelper
  include ProjectHelper

  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    status_retrieve("3637946596783717")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    respond_to do |format|
      @project = current_user.projects.in_edit.first
      if current_user.has_role?(:member) && @project.present?
        format.html { redirect_to edit_project_url(@project) }
      else
        @project = Project.new
        @project.build_basic_info
        format.html # new.html.erb
        format.json { render json: @project }
      end
    end
  end

  def edit
    @project = Project.find(params[:id])

    %w(story owner).each do |klass|
      @project.send("build_#{klass}") if params[:step] == "#{klass}" && @project.send("#{klass}").nil?
    end
  end

  def create
    project_params = params[:project].merge(user_id: current_user.id)
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_url(@project, { step: params[:next] }) }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        if params[:next] == 'preview'
          format.html { redirect_to preview_project_url(@project) }
        elsif %w(info story owner submit).include?(params[:next])
          format.html { redirect_to edit_project_url(@project, { step: params[:next] }) }
        else
          format.html { redirect_to edit_project_url(@project) }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @project = Project.find(params[:id])
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def submit
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.submit!
      format.html { redirect_to project_url(@project), notice: '提交成功!等待审核中...' }
    rescue => e
      format.html { redirect_to preview_project_url(@project) , alert: '提交失败！' }
    end
    end
  end

  def publish
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.publish!
      format.html { redirect_to projects_url, notice: '发布成功!' }
    rescue => e
      format.html { render action: "index" }
    end
    end
  end

  def unpublish
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.unpublish!
      format.html { redirect_to projects_url, notice: '取消发布成功!' }
    rescue => e
      format.html { render action: "index" }
    end
    end
  end
end
