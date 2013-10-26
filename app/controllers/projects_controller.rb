class ProjectsController < ApplicationController
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new
    @project.build_basic_info

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])

    %w(story owner).each do |klass|
      @project.send("build_#{klass}") if params[:step] == "#{klass}" && @project.send("#{klass}").nil?
    end
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to edit_project_url(@project, { step: params[:next] }), notice: 'project was successfully created.' }
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
        #params[:step] ||= 'info'
        #step = next_step_of(params[:step]) # in ProjectHelper
        if params[:next] == 'preview'
          format.html { redirect_to preview_project_url(@project), notice: 'project was successfully updated.' }
        else
          format.html { redirect_to edit_project_url(@project, { step: params[:next] }) }
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
end
