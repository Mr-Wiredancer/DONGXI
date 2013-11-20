class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.string :trade_no
      t.integer :amount
      t.integer :project_id

      t.timestamps
    end
  end
end
