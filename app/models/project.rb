class Project < ActiveRecord::Base
  attr_accessible :name, :slogan, :introduction, :note, :category_id, :region_id, :user_id, :sponsor_id, :end_time, :amount, :region

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor, class_name: "Sponsor"

end
