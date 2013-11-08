class ProjectStory < ActiveRecord::Base
  attr_accessible :introduction, :risk, :video_url

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :introduction, presence: true
    condition.validates :risk, presence: true
    condition.validates :video_url, presence: true, format: { with: /([http|https]:\/\/)?[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+/ }
  end

  def in_submit?
    project && project.in_submit?
  end
end
