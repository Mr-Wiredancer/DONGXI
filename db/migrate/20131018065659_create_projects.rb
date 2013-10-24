class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slogan
      t.text :introduction
      t.text :note
      t.integer :category_id
      t.integer :region_id
      t.integer :user_id
      t.integer :video_id
      t.integer :sponsor_id
      t.datetime :end_time
      t.integer :amount

      #t.string :sponsor
      #t.text :video

      t.timestamps
    end
  end
end
