class AddCommentIdToImages < ActiveRecord::Migration
  def up
  	add_column :images, :comment_id, :integer
  end
  def down
  	remove_column :images, :comment_id 
  end
end
