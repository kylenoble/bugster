class Request < ActiveRecord::Base
	belongs_to :user

	has_many :comments, :dependent => :destroy 
	has_many :images, :dependent => :destroy
	
	scope :completed, -> { where(status: 'Completed') }
	scope :open, -> { where.not(status: 'Completed') }
	accepts_nested_attributes_for :images, :allow_destroy => true
	paginates_per 10
end
