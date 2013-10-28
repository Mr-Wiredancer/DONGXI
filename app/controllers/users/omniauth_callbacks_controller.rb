# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def weibo
    auth = env["omniauth.auth"]
    authorization = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"].to_s)

    if not current_user.blank?
      current_user.bind_service(auth)
      redirect_to root_url, :notice => "成功绑定微博账号!"
    elsif authorization
      # redirect to home page if the user exists
      flash[:notice] = "微博账号登录成功!"
      sign_in_and_redirect authorization.user, :event => :authentication, :notice => "登录成功!"
    else
      # redirect to sign_up page
      #@user = User.find_or_build_for_weibo(auth)

      session[:omniauth] = auth.except("extra")
      redirect_to new_user_registration_url, :notice => "欢迎使用微博登录！补充您的信息吧。"
    end
  end

end
