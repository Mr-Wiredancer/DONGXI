class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string    :name
      t.string    :slogan
      t.text      :introduction
      t.text      :risk
      t.integer   :category_id
      t.integer   :region_id
      t.integer   :user_id
      t.string    :video_url
      t.string    :photo_url
      t.integer   :sponsor_id
      t.datetime  :start_time
      t.datetime  :end_time
      t.integer   :amount
      t.string    :owner_avatar_url
      t.string    :owner_name
      t.string    :owner_introduction
      t.string    :owner_website_url

      t.timestamps
    end
  end
end
