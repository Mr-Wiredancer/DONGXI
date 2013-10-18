class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :title
      t.text :description
      t.string :sponsor
      t.text :video

      t.timestamps
    end
  end
end
