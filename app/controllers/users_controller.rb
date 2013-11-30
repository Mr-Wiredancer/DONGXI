# coding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!
  #load_and_authorize_resource #:except => [:projects]

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET
  def projects
    # TODO: display only one project
    @projects = current_user.projects
  end


end
