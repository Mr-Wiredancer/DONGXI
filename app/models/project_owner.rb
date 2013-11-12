class ProjectOwner < ActiveRecord::Base
  attr_accessible :introduction, :name, :website_url, :avatar

  has_attached_file :avatar,  :styles => { :normal => ["100x100#", :png] },
                              :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                              :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :introduction,  presence: true
    condition.validates :name,          presence: true
    condition.validates :website_url,   presence: true, format: { with: /([http|https]:\/\/)?[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+/}
    condition.validates :avatar,        presence: true
  end

  def in_submit?
    project && project.in_submit?
  end

end
