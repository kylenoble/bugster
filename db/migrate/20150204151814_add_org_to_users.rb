class AddOrgToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :org, :integer
  end
end
