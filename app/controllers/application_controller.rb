# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def check_admin
    unless current_user.is_admin?
      redirect_to root_url, :notice => '噢噢你不是管理猿！'
    end
  end
end
