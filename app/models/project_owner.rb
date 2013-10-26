class ProjectOwner < ActiveRecord::Base
  attr_accessible :introduction, :name, :website_url, :avatar

  has_attached_file :avatar,  :styles => { :normal => ["100x100#", :png] },
                              :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                              :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

end
