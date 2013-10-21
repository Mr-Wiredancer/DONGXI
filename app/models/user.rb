class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :omniauthable, :omniauth_providers => [:weibo]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :name

  has_many :authorizations do
    def find_or_create_by_params(params)
      provider,uid = params[:provider],params[:uid]
      access_token,access_token_secret = params[:access_token],params[:access_token_secret]

      authorization = find_or_create_by_provider_and_uid(provider, uid.to_s)
      authorization.update_attributes!(params.except(:provider, :uid))
    end
  end
end
