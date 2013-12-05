# coding: utf-8
class Cpanel::ApplicationController < ApplicationController
	layout "cpanel"
  before_filter :authenticate_user!
  before_filter :require_admin

  def require_admin
    unless current_user.has_role?(:admin)
      redirect_to root_path, notice: "访问被拒绝，你可能没有权限或未登录。"
    end
  end

end
