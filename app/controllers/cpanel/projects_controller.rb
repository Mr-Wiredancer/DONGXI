# coding: utf-8
class Cpanel::ProjectsController < Cpanel::ApplicationController
  def index
    @projects = Project.all
  end

  def volunteers
    @project = Project.find(params[:id])
  end
end