class CreateProjectBasicInfos < ActiveRecord::Migration
  def change
    create_table :project_basic_infos do |t|
      t.string    :name
      t.integer   :category_id
      t.string    :slogan
      t.integer   :region_id
      t.integer   :amount
      t.integer   :project_id
      t.datetime  :start_time
      t.datetime  :end_time
      t.attachment :photo

      t.timestamps
    end
  end
end
