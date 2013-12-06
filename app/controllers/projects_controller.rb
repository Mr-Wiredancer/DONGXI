# coding: utf-8
class ProjectsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  include ApplicationHelper
  include ProjectHelper

  def index
    @projects = Project.in_publish
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    respond_to do |format|
      @project = current_user.current_project
      if @project.present?
        format.html { redirect_to edit_project_url(@project, step: 'info') }
      else
        @project = Project.create(user_id: current_user.id)
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

  def preview # preview.html.erb
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

  def submit # GET
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.submit!
      if current_user.admin?
        format.html { redirect_to cpanel_projects_url, notice: '提交成功!等待审核中...' }
      else
        format.html { redirect_to preview_project_url(@project), notice: '提交成功!等待审核中...' }
      end
    rescue => e
      format.html { redirect_to preview_project_url(@project) , alert: '提交失败！' }
    end
    end
  end


  def donate # POST
    @project = Project.find(params[:id])
    respond_to do |format|
    begin
      @project.add_donation(params)
      format.html { redirect_to project_url(@project), notice: '捐款成功!' }
    rescue => e
      format.html { redirect_to project_url(@project), notice: '捐款出现了点问题。。' }
    end
    end
  end

  # POST project/:id/add_volunteer.json
  def add_volunteer
    project = Project.find(params[:id])
    project.add_volunteer(params[:user_id].to_i)
    render json: { message: 'ok', amount: project.volunteer_amount }
  end

  # POST project/:id/remove_volunteer.json
  def remove_volunteer
    project = Project.find(params[:id])
    project.remove_volunteer(params[:user_id].to_i)
    render json: { message: 'ok', amount: project.volunteer_amount }
  end

end
