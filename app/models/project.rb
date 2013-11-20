# coding: utf-8
class Project < ActiveRecord::Base
  # constants
  STATUS = {
    in_edit:      { weight: 0, description: '编辑中' },
    in_audit:     { weight: 1, description: '审核中' },
    in_publish:   { weight: 2, description: '已发布' },
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

  attr_accessor :submitting

  # associations
  has_one   :basic_info, class_name: "ProjectBasicInfo", dependent: :destroy
  has_one   :story, class_name: "ProjectStory", dependent: :destroy
  has_one   :owner, class_name: "ProjectOwner", dependent: :destroy
  has_one   :weibo_status, class_name: "WeiboStatus", dependent: :destroy

  has_many  :donations, class_name: "Donation", dependent: :destroy

  accepts_nested_attributes_for :basic_info, :story, :owner

  belongs_to :category
  belongs_to :user
  belongs_to :region
  belongs_to :sponsor

  # validations
  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :status,      inclusion: { in: 0..2 }
    condition.validates :basic_info,  presence: true, associated: true
    condition.validates :story,       presence: true, associated: true
    condition.validates :owner,       presence: true, associated: true
    condition.validates_presence_of :category_id, :region_id, :user_id
  end

  # callbacks
  before_validation :set_default

  # scopes
  scope :in_publish, where(status: Project::STATUS[:in_publish][:weight])
  scope :in_edit, where(status: Project::STATUS[:in_edit][:weight])

  scope :title_like, lambda { |key| includes(:basic_info).where("LOWER(project_basic_infos.name) LIKE ?", "%#{key.downcase}%") }
  scope :text_like, lambda { |key| includes(:story).where("LOWER(project_stories.introduction) LIKE ?", "%#{key.downcase}%") }

  scope :search, lambda {|params={}|
    projects = in_publish
    projects = projects.title_like(params[:key]) | projects.text_like(params[:key]) if params[:key].present?
    projects
  }

  # methods
  %w(name slogan photo amount duration_days published_time raise_type).each do |info_attr|
    delegate info_attr, to: :basic_info, prefix: false, allow_nil: true
  end

  %w(introduction risk video_url weibo_url).each do |story_attr|
    delegate story_attr, to: :story, prefix: false, allow_nil: true
  end
  %w(name introduction website_url avatar).each do |owner_attr|
    delegate owner_attr, to: :owner, prefix: true, allow_nil: true
  end
  delegate :name, to: :region, prefix: true, allow_nil: true
  delegate :name, to: :category, prefix: true, allow_nil: true

  def set_default
    if self.new_record?
      self.status = 0
      self.raised_amount = 0
    end
  end

  %w(edit audit publish).each do |method_name|
    define_method "in_#{method_name}?" do
      status == STATUS["in_#{method_name}".to_sym][:weight]
    end
  end

  def in_submit?
    self.submitting == true
  end

  def submit!
    self.submitting = true
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

  def add_donation!(options)
    options.slice!(:trade_no, :amount, :user_id)
    self.raised_amount =  options[:amount].to_i + self.raised_amount
    self.donations << Donation.create(options)
    self.save!
    # NOTICE: change project status when donation is enough??
  end
end
