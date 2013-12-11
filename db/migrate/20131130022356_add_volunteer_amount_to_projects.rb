class AddVolunteerAmountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :volunteer_amount, :integer
  end
end
