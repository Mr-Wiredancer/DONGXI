class Project < ActiveRecord::Base
  attr_accessible :basic_info_attributes,
                  #:photo,
                  #:name,
                  #:category_id,
                  #:slogan,
                  #:region_id,
                  #:start_time,
                  #:end_time,
                  #:amount,
                  :story_attributes,
                  #:video_url,
                  #:introduction,
                  #:risk,
                  :owner_attributes,
                  #:owner_avatar_url,
                  #:owner_name,
                  #:owner_website_url,
                  #:owner_introduction,
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
