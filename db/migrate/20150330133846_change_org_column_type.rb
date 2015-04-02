class ChangeOrgColumnType < ActiveRecord::Migration
  def up
  	change_column :bugs, :org, :string
  	change_column :requests, :org, :string
  	change_column :users, :org, :string
  end
  def down
  	change_column :bugs, :org, :integer
  	change_column :requests, :org, :integer
  	change_column :users, :org, :integer
  end
end
