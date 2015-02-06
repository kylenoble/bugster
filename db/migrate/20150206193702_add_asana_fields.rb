class AddAsanaFields < ActiveRecord::Migration
  def up
  	add_column :bugs, :task_id,  :string
  	add_column :requests, :task_id, :string
  	add_column :comments, :story_id, :string
  end
  def down
  	remove_column :bugs, :task_id
  	remove_column :requests, :task_id
  	remove_column :comments, :story_id
  end
end
