class AddRequestIdToComments < ActiveRecord::Migration
  def change
  	add_column :images, :request_id, :integer
  	add_column :comments, :request_id, :integer
  	add_index :images, :request_id
  	add_index :comments, :request_id
  end
end
