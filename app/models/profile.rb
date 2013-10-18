class Profile < ActiveRecord::Base
  attr_accessible :description, :sponsor, :title, :video
end
