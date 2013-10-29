class Project < ActiveRecord::Base
  attr_accessible :basic_info_attributes,
                  :category_id,
                  :region_id,
                  :story_attributes,
                  :owner_attributes,
                  :user_id,
                  :sponsor_id

  has_one   :basic_info, class_name: "ProjectBasicInfo", dependent: :destroy
  has_one   :story, class_name: "ProjectStory", dependent: :destroy
  has_one   :owner, class_name: "ProjectOwner", dependent: :destroy

  accepts_nested_attributes_for :basic_info, :story, :owner

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor, class_name: "Sponsor"

end
