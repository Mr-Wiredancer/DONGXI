class Participation < ActiveRecord::Base
  attr_accessible :project_id, :volunteer_id

  belongs_to :project
  belongs_to :volunteer, class_name: "User", foreign_key: "volunteer_id"
end
