class CreateMasterData < ActiveRecord::Migration
  def change
    create_table :master_data do |t|
      t.string :name
      t.text :description
      t.string :type
      t.integer :parent_id

      t.timestamps
    end
  end
end
