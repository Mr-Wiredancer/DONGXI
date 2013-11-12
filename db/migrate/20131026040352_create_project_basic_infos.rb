class CreateProjectBasicInfos < ActiveRecord::Migration
  def change
    create_table :project_basic_infos do |t|
      t.attachment :photo
      t.string    :name
      t.string    :slogan
      t.integer   :amount
      t.integer   :duration_days
      t.datetime  :published_time
      t.integer   :raise_type
      t.integer   :project_id

      t.timestamps
    end
  end
end
