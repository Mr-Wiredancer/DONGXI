class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer   :category_id
      t.integer   :region_id
      t.integer   :user_id
      t.integer   :sponsor_id
      t.integer   :raised_amount
      t.datetime  :published_time
      t.integer   :status

      t.timestamps
    end
  end
end
