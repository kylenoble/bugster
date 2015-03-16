class Comment < ActiveRecord::Base
	belongs_to :bug
	belongs_to :request
	has_many :images, :dependent => :destroy

	validates_presence_of :user_name 
  validates_length_of :user_name, :within => 2..20 
  validates_presence_of :body 
  paginates_per 10
end
