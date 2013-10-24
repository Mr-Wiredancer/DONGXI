class Category < MasterData
  attr_accessible :description, :name

  has_many :projects
end
