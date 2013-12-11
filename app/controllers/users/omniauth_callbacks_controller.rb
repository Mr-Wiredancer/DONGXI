# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :initialize_auth
  def weibo
    omniauth_login_or_signup("weibo")
  end

  def renren
    omniauth_login_or_signup("renren")
  end

  private

  def initialize_auth
    @auth = env["omniauth.auth"]
    @authorization = Authorization.find_by_provider_and_uid(@auth["provider"], @auth["uid"].to_s)
  end

  def omniauth_login_or_signup(provider_name)
    provider_name = I18n.t("common.provider.#{provider_name}")
    if not current_user.blank? # bind
      current_user.bind_service(@auth)
      redirect_to edit_user_registration_url, :notice => "成功绑定#{provider_name}账号!"
    elsif @authorization # login
      flash[:notice] = "#{provider_name}账号登录成功!"
      sign_in_and_redirect @authorization.user, :event => :authentication#, :notice => "#{provider_name}账号登录成功!"
    else # sign_up
      session[:omniauth] = @auth.except("extra")
      redirect_to new_user_registration_url, :notice => "欢迎使用#{provider_name}登录！补充您的信息吧。"
    end
  end
end
