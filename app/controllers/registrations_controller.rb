class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

  private

  def build_resource(*args)
    super
    if session[:omniauth]
      @user.authorizations.build(provider: session[:omniauth]["provider"], uid: session[:omniauth]["uid"].to_s)
      @user.name = session[:omniauth]["info"]["name"]
    end
  end
end
