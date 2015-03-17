require 'elasticsearch/model'

class Bug < ActiveRecord::Base
	include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

	has_many :comments, :dependent => :destroy 
	has_many :images, :dependent => :destroy

	scope :completed, -> { where(status: 'Completed') }
	scope :open, -> { where.not(status: 'Completed') }
	accepts_nested_attributes_for :images, :allow_destroy => true
	
	def self.search(query)
	  __elasticsearch__.search(
	    {
	      query: {
	        multi_match: {
	          query: query,
	          fields: ['title^10', 'details', 'reporter', 'email', 'category']
	        }
	      }
	    }
	  )
	end

	paginates_per 10
end
Bug.import