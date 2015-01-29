class AddBugIdToImages < ActiveRecord::Migration
  def change
  	add_column :images, :bug_id, :integer
  end
end
