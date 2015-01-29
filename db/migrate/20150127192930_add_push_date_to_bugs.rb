class AddPushDateToBugs < ActiveRecord::Migration
  def change
  	add_column :bugs, :push_date, :string, :default => "TBA"
  end
end
