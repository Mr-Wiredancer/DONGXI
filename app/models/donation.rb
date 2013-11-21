class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :trade_no, :user_id

  belongs_to :project
  belongs_to :user

  validates :trade_no, presence: true, length: { is: 28 }, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :user, :project
end
