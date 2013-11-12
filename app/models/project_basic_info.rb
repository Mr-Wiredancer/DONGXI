# coding: utf-8
class ProjectBasicInfo < ActiveRecord::Base
  RAISE_TYPE = {
    money:      { weight: 1, description: '金钱' },
    volunteer:  { weight: 2, description: '志愿者' }
  }
  attr_accessible :photo,
                  :name,
                  :slogan,
                  :amount,
                  :duration_days,
                  :published_time,
                  :raise_type

  has_attached_file :photo, :styles => { :normal => ["640x480#", :png] },
                            :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                            :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :amount,          presence: true, inclusion:  { in: 1..1_000_000 }
    condition.validates :name,            presence: true, length:     { in: 1..30 }
    condition.validates :slogan,          presence: true, length:     { in: 1..110 }
    condition.validates :photo,           presence: true
    condition.validates :duration_days,   presence: true, numericality: true
    condition.validates :published_time,  presence: true
    condition.validates :raise_type,      presence: true, inclusion: { in: RAISE_TYPE.map{ |k,v| v[:weight] } }
    #condition.validate :time_check
  end

  #def time_check
    #if start_time && end_time
      #errors.add(:end_time, "End Time should be later than Start Time") if end_time < start_time
    #end
  #end

  def in_submit?
    self.project && self.project.in_submit?
  end

end
