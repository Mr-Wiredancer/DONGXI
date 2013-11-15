class WeiboStatus < ActiveRecord::Base
  attr_accessible :status_mid, :status_id, :project_id, :parent_id

  belongs_to :parent, class_name: "WeiboStatus", inverse_of: :reposts, foreign_key: "parent_id"
  # should we declare destroy dependency here?
  has_many :reposts, class_name: "WeiboStatus", inverse_of: :parent, foreign_key: "parent_id", dependent: :destroy
end
