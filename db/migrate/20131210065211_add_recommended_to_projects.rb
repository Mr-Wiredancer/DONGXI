class AddRecommendedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :recommended, :boolean 

    Project.all.each { |p| p.recommended = false; p.save }
  end
end
