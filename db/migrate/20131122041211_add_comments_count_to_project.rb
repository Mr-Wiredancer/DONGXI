class AddCommentsCountToProject < ActiveRecord::Migration
  def change
    add_column :projects, :comments_count, :integer

    Comment.find_each { |comment| comment.save! }
  end
end
