class Project < ActiveRecord::Base
  attr_accessible :name, :slogan, :introduction, :note, :category_id, :region_id, :user_id, :sponsor_id, :start_time, :end_time, :amount, :region, :photo_url, :video_url, :risk, :owner_avatar_url, :owner_name, :owner_website_url, :owner_introduction, :photo

  has_attached_file :photo, :styles => { :normal => ["640x480#", :png] },
                            :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                            :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor, class_name: "Sponsor"

end
