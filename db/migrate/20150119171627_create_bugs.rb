class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :details
      t.string :bugster
      t.string :email
      t.integer :org
      t.string :status

      t.timestamps
    end

    add_index :bugs, :org
    add_index :bugs, :status
  end
end
