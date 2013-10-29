# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  def check_admin
    unless %w(tkd泽秋_吃饭团小短腿 利嘉豪Wiredancer dxtechnology).include?(current_user.name)
      redirect_to root_url, :notice => '噢噢你不是管理猿！'
    end
  end
end
