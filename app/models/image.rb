class Image < ActiveRecord::Base
	belongs_to :bug

	validates :bug, :presence => true

	has_attached_file :image, :styles => { :lrg => "700x700>", :med => "350x350>", :sml => "100x100>" }, :whiny => false,
			      :storage => :s3,
			      :bucket  => ENV['AWS_BUCKET_NAME'],
    				:s3_credentials => 
    				{ :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      				:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] },
    				:path => "/images/:attachment/:id/:style/:filename",
						:url => "bugster.s3-website-us-east-1.amazonaws.com" 
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end