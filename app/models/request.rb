class Request < ActiveRecord::Base
	belongs_to :user

	has_many :comments, :dependent => :destroy 
	has_many :images, :dependent => :destroy

	accepts_nested_attributes_for :images, :allow_destroy => true
	paginates_per 10
end
