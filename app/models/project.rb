class Project < ActiveRecord::Base
  attr_accessible :basic_info_attributes,
                  :category_id,
                  :region_id,
                  :story_attributes,
                  :owner_attributes,
                  :user_id,
                  :sponsor_id,
                  :published

  has_one   :basic_info, class_name: "ProjectBasicInfo", dependent: :destroy
  has_one   :story, class_name: "ProjectStory", dependent: :destroy
  has_one   :owner, class_name: "ProjectOwner", dependent: :destroy

  accepts_nested_attributes_for :basic_info, :story, :owner

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor, class_name: "Sponsor"

  scope :published, where(published: true)

  scope :title_like, lambda { |key| includes(:basic_info).where("LOWER(project_basic_infos.name) LIKE ?", "%#{key.downcase}%") }
  scope :text_like, lambda { |key| includes(:story).where("LOWER(project_stories.introduction) LIKE ?", "%#{key.downcase}%") }

  scope :search, lambda {|params={}|
    projects = published
    #projects = projects.includes(:basic_info).where("LOWER(project_basic_infos.name) LIKE LOWER(?)", "%#{params[:key]}%")
    projects = projects.title_like(params[:key]) | projects.text_like(params[:key]) if params[:key].present?
    projects
  }

  def publish!
    self.update_attribute(:published, true)
  end

  def unpublish!
    self.update_attribute(:published, false)
  end
end
