class CreateProjectOwners < ActiveRecord::Migration
  def change
    create_table :project_owners do |t|
      t.string      :name
      t.string      :website_url
      t.text        :introduction
      t.integer     :project_id
      t.string      :id_card_num
      t.attachment  :avatar

      t.timestamps
    end
  end
end
