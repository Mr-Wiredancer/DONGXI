class Comment < ActiveRecord::Base
  attr_accessible :body, :project_id, :user_id

  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: "user_id"

  # validation
  validates_presence_of :project, :author

  delegate :name, to: :author, prefix: true, allow_nil: true

  after_save do
    self.project.update_comments_count
  end

end
