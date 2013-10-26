class CreateProjectStories < ActiveRecord::Migration
  def change
    create_table :project_stories do |t|
      t.string :video_url
      t.text :introduction
      t.text :risk
      t.integer :project_id

      t.timestamps
    end
  end
end
