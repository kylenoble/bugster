class AddPriorityAndReporterToBugsAndRequests < ActiveRecord::Migration
  def up
  	add_column :bugs, :priority, :string
  	add_column :bugs, :reporter, :string
  	add_column :requests, :priority, :string
  	add_column :requests, :requestor, :string
  end
  def down
  	remove_column :bugs, :priority
  	remove_column :bugs, :reporter
  	remove_column :requests, :priority
  	remove_column :requests, :requestor
  end
end
