class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :trade_no, :user_id

  belongs_to :project
  belongs_to :donor, class_name: "User", foreign_key: "user_id"

  validates :trade_no, presence: true, length: { is: 28 }, uniqueness: true
  #validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :donor, :project

  delegate :name, to: :donor, prefix: true, allow_nil: false

end
