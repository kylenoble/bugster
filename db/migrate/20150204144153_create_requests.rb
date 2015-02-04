class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.text :details
      t.string :email
      t.belongs_to :user
      t.integer :org
      t.string :status, default: "Requested"
      t.string :category
      t.string :push_date,  default: "TBA"

      t.timestamps
    end
    add_index :requests, :user_id
    add_index :requests, :org
  end
end
