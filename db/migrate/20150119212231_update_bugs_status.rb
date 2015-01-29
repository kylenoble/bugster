class UpdateBugsStatus < ActiveRecord::Migration
  def change
  	change_column :bugs, :status, :string, :default => "Reported"
  end
end
