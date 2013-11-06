# coding: utf-8
class User < ActiveRecord::Base
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :projects

  has_many :authorizations do
    def find_or_create_by_params(params)
      provider,uid = params[:provider],params[:uid].to_s
      find_or_create_by_provider_and_uid(provider, uid)
    end
  end

  def bind_service(response)
    auth_params = {
      provider: response["provider"],
      uid: response["uid"].to_s,
    }
    authorizations.find_or_create_by_params(auth_params)
  end

  def admin?
    %w(tkd泽秋_吃饭团小短腿 利嘉豪Wiredancer dxtechnology tester).include?(self.name)
  end

  def has_role?(role)
    case role
    when :admin then admin?
    when :member then !admin? && valid?
    else false
    end
  end

  def weibo
    self.authorizations(provider: 'weibo').first
  end

  def weibo_id
    self.weibo.uid
  end

end
