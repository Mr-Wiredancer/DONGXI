class User < ActiveRecord::Base
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :authorizations do
    def find_or_create_by_params(params)
      provider,uid = params[:provider],params[:uid].to_s
      access_token,access_token_secret = params[:access_token],params[:access_token_secret]

      authorization = find_or_create_by_provider_and_uid(provider, uid)
      authorization.update_attributes!(params.except(:provider, :uid))
    end
  end

  def bind_service(response)
    auth_params = {
      provider: response["provider"],
      uid: response["uid"].to_s,
      access_token: response["credentials"]["token"]
    }
    authorizations.find_or_create_by_params(auth_params)
  end

end
