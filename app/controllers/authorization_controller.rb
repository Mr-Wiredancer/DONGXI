class AuthorizationController < ApplicationController
  def oauth_create
    auth = request.env["omniauth.auth"]
    user = current_user
    user.authorizations.find_or_create_by_params({
      :provider => auth["provider"],
      :uid => auth["uid"],
    })
    flash[:notice] = "#{auth['provider']} user #{auth['uid']} successfully authenticated!"
    redirect_to root_url
  end

  def oauth_destroy
  end
end
