class MasterData < ActiveRecord::Base
  attr_accessible :description, :name, :parent_id, :type
end
