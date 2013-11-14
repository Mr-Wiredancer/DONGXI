class Image < ActiveRecord::Base
  # attr_accessible :title, :body
  has_attached_file :data
end
