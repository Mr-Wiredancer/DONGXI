# coding: utf-8
class Project < ActiveRecord::Base
  # constants
  STATUS = {
    in_edit:      { weight: 0, description: '编辑中' },
    in_audit:     { weight: 1, description: '审核中' },
    in_publish: { weight: 2, description: '已发布' },
  }

  # attr* macros
  attr_accessible :basic_info_attributes,
                  :category_id,
                  :region_id,
                  :story_attributes,
                  :owner_attributes,
                  :user_id,
                  :sponsor_id,
                  :status

  # associations
  has_one   :basic_info, class_name: "ProjectBasicInfo", dependent: :destroy
  has_one   :story, class_name: "ProjectStory", dependent: :destroy
  has_one   :owner, class_name: "ProjectOwner", dependent: :destroy

  accepts_nested_attributes_for :basic_info, :story, :owner

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor, class_name: "Sponsor"

  # validations
  validates :status, inclusion: { in: 0..2 }

  # callbacks
  before_validation :set_default_status

  # scopes
  scope :published, where(status: Project::STATUS[:in_publish][:weight])
  scope :title_like, lambda { |key| includes(:basic_info).where("LOWER(project_basic_infos.name) LIKE ?", "%#{key.downcase}%") }
  scope :text_like, lambda { |key| includes(:story).where("LOWER(project_stories.introduction) LIKE ?", "%#{key.downcase}%") }

  scope :search, lambda {|params={}|
    projects = published
    projects = projects.title_like(params[:key]) | projects.text_like(params[:key]) if params[:key].present?
    projects
  }

  # methods

  def set_default_status
    self.status = 0 if self.new_record?
  end

  %w(edit audit publish).each do |method_name|
    define_method "in_#{method_name}?" do
      status == STATUS["in_#{method_name}".to_sym][:weight]
    end
  end

  def submit!
    self.update_attributes!(status: 1) if in_edit?
  end

  def publish!
    self.update_attributes!(status: 2) if in_audit?
  end

  def unpublish!
    self.update_attributes!(status: 0) if in_audit?
  end

  def status_name
    STATUS.select{ |k,v| v[:weight] == status }.values[0][:description]
  end

end
