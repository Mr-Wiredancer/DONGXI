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

  def auth_unbind
    provider = params[:provider]

    current_user.authorizations.where(provider: provider).destroy_all
    redirect_to edit_user_registration_path, :flash => { :warning => "解除绑定成功" }
  end

end
