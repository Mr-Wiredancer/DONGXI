class ProjectOwner < ActiveRecord::Base
  attr_accessible :introduction, :name, :website_url, :avatar, :id_card_num

  has_attached_file :avatar,  :styles => { :normal => ["100x100#", :png] },
                              :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                              :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension",
                              :default_url => ":assets_host/images/project/avatar/:style/missing.png"

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :name,          presence: true
    condition.validates :introduction,  presence: true
    condition.validates :website_url,   presence: true, format: { with: /([http|https]:\/\/)?[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+/}
    #condition.validates :avatar,        attachment_presence: true
    condition.validates :id_card_num,   presence: true, format: { with: /(^\d{15}$)|(^\d{17}[0-9Xx]{1}$)/ }
  end

  def in_submit?
    project && project.in_submit?
  end

end
