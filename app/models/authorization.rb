class Authorization < ActiveRecord::Base
  attr_accessible :access_token, :access_token_secret, :provider, :uid, :user_id

  belongs_to :user

  #validates :user_id, :uid, :provider, :presence => true
  validates :uid, :provider, :presence => true
  validates :uid, :uniqueness => { :scope => :provider }
end
