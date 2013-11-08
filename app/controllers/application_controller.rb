# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, notice: "访问被拒绝，你可能没有权限或未登录。"
  end

  #rescue_from AbstractController::ActionNotFound do |exception|
    #redirect_to root_path, notice: 'some problems'
  #end

end
