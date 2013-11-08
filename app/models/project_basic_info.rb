class ProjectBasicInfo < ActiveRecord::Base
  attr_accessible :amount, :name, :slogan, :photo, :start_time, :end_time

  has_attached_file :photo, :styles => { :normal => ["640x480#", :png] },
                            :url    => ":assets_host/content/:class/:attachment/:hash/:style.:extension",
                            :path   => ":rails_root/public/content/:class/:attachment/:hash/:style.:extension"

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :amount,      presence: true, inclusion:  { in: 0..1_000_000 }
    condition.validates :name,        presence: true, length:     { in: 6..30 }
    condition.validates :slogan,      presence: true, length:     { in: 6..110 }
    condition.validates :photo,       presence: true
    condition.validates :start_time,  presence: true
    condition.validates :end_time,    presence: true
    condition.validate :time_check
  end

  def time_check
    if start_time && end_time
      errors.add(:end_time, "End Time should be later than Start Time") if end_time < start_time
    end
  end

  def in_submit?
    self.project && self.project.in_submit?
  end

end
