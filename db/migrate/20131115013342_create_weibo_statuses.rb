class CreateWeiboStatuses < ActiveRecord::Migration
  def change
    create_table :weibo_statuses do |t|
      t.string :status_mid
      t.string :status_id
      t.integer :project_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
