class ProjectBasicInfo < ActiveRecord::Base
  attr_accessible :amount, :category_id, :name, :region_id, :slogan, :photo, :start_time, :end_time

  has_attached_file :photo, :styles => { :normal => ["640x480#", :png] },
                            :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                            :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

end
