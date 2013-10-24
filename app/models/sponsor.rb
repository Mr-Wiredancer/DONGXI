class Sponsor < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :projects
end
