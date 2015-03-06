class AddAdminSecretToAdmins < ActiveRecord::Migration
  def up
  	add_column :admins, :admin_secret, :string
  end
  def down 
  	remove_column :admins, :admin_secret
  end
end
