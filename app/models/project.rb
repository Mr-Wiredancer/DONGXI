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
                  :published_time,
                  :comments_count,
                  :raised_amount,
                  :volunteer_amount,
                  :status

  attr_accessor :submitting

  # associations
  has_one   :basic_info, class_name: "ProjectBasicInfo", dependent: :destroy
  has_one   :story, class_name: "ProjectStory", dependent: :destroy
  has_one   :owner, class_name: "ProjectOwner", dependent: :destroy
  has_one   :weibo_status, class_name: "WeiboStatus", dependent: :destroy

  has_many  :donations, class_name: "Donation", dependent: :destroy
  has_many  :participations, dependent: :destroy
  has_many  :volunteers, through: :participations
  has_many  :comments, dependent: :destroy

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
  def set_default
    if self.new_record?
      self.status = 0
      self.raised_amount = 0
      self.volunteer_amount = 0
    end
  end

  # scopes
  %w[in_publish in_edit in_audit].each do |scope_name|
    scope scope_name.to_sym, where(status: Project::STATUS[scope_name.to_sym][:weight])
  end

  scope :info_like, lambda { |key| includes(:basic_info)
                             .where("(LOWER(project_basic_infos.name) LIKE ?) OR (LOWER(project_basic_infos.slogan) LIKE ?) ",
                                    "%#{key.downcase}%", "%#{key.downcase}%") }
  scope :introduction_like, lambda { |key| includes(:story).where("LOWER(project_stories.introduction) LIKE ?", "%#{key.downcase}%") }
  scope :owner_like, lambda { |key| includes(:owner).where("LOWER(project_owners.name) LIKE ?", "%#{key.downcase}%") }

  #scope
  scope :search, lambda {|params={}|
    projects = in_publish
    projects = projects.info_like(params[:key]) | projects.introduction_like(params[:key]) | projects.owner_like(params[:key]) if params[:key].present?
    projects
  }

  # methods

  # get something
  %w(name slogan photo amount duration_days raise_type).each do |info_attr|
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

  def status_name
    STATUS.select{ |k,v| v[:weight] == status }.values[0][:description]
  end

  # check status
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

  # manipulation
  def publish!
    if in_audit?
      self.update_attributes!(status: 2, published_time: Time.now)
    end
  end

  def unpublish!
    self.update_attributes!(status: 0) if in_audit?
  end

  def add_donation(options)
    options.slice!(:trade_no, :user_id)
    self.donations << Donation.new(options)
    self.save!
  end

  def add_volunteer(user_id)
    user = User.find(user_id)
    unless (self.volunteer_ids.include?(user_id) || user.nil?)
      self.volunteers << user
      amount = (self.volunteer_amount || 0) + 1
      self.update_attributes(volunteer_amount: amount)
      self.save
    end
  end

  def remove_volunteer(user_id)
    if self.volunteer_ids.include?(user_id)
      self.participations.where(volunteer_id: user_id).delete_all
      self.update_attributes(volunteer_amount: self.volunteer_amount - 1)
    end
  end

  def volunteer_ids
    self.volunteers.map(&:id)
  end

  def update_comments_count
    self.update_attributes!(comments_count: comments.count)
  end

end
