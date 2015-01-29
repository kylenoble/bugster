class AddCategoryToBugs < ActiveRecord::Migration
  def change
    add_column :bugs, :category, :string
  end
end
