# coding: utf-8
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def weibo
    auth = env["omniauth.auth"]
    if not current_user.blank?
      current_user.bind_service(auth)
      redirect_to root_url, :notice => "成功绑定微博账号!"
    else
      @user = User.find_or_create_for_weibo(auth)

      if @user.persisted?
        flash[:notice] = "微博账号登录成功!"
        sign_in_and_redirect @user, :event => :authentication, :notice => "登录成功!"
      else
        redirect_to new_user_registration_url, :notice => "FUCK"
      end
    end
  end

end
