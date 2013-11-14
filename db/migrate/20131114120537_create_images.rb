class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :data

      t.timestamps
    end
  end
end
