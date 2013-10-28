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
  #def update
    ## required for settings form to submit when password is left blank
    #if params[:user][:password].blank?
      #params[:user].delete("password")
      #params[:user].delete("password_confirmation")
    #end

    #@user = User.find(current_user.id)
    #if @user.update_attributes(params[:user])
      #set_flash_message :notice, :updated
      ## Signed in the user bypassing validation in case his password changed
      #sign_in @user, :bypass => true
      #redirect_to after_update_path_for(@user)
    #else
      #render "edit"
    #end
  #end
end
