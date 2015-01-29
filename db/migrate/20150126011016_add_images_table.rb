class AddImagesTable < ActiveRecord::Migration
  def self.up
  	create_table :images do |t|
  		t.attachment :image
  	end
  end
  def self.down
  	drop_table :images
  end
end
