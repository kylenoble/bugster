class Image < ActiveRecord::Base
	belongs_to :bug
	belongs_to :request
	belongs_to :comment

	after_create :upload_asana_attachment

	def image_contents
    self.copy_to_local_file.read
  end

	has_attached_file :image, :styles => { :lrg => "700x700>", :med => "350x350>"}, :whiny => false,
			      :storage => :s3,
			      :bucket  => ENV['AWS_BUCKET_NAME'],
    				:s3_credentials =>
    				{ :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      				:secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] },
    				:path => "/images/:attachment/:id/:style/:filename",
						:url => "bugster.s3-website-us-east-1.amazonaws.com"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates_attachment_size :image, :less_than => 2.megabytes

	process_in_background :image, processing_image_url: "/assets/loading-3bb95d6378ca245cbc9e5458fd0afe85.gif"

	def upload_asana_attachment
		puts self
		if self.bug_id
			@trello_card = Trello::Card.find(self.bug.task_id)
      @trello_card.add_attachment(image)
    elsif self.request_id
			@trello_card = Trello::Card.find(self.request.task_id)
      @trello_card.add_attachment(image)
    elsif self.comment_id
    	@comment = Comment.find(self.comment_id)
    	if @comment.bug_id
				@bug = Bug.find(@comment.bug_id)
				@trello_card = Trello::Card.find(@bug.task_id)
				@trello_card.add_attachment(image)
	    else
				@request = Request.find(@comment.request_id)
				@trello_card = Trello::Card.find(@request.task_id)
				@trello_card.add_attachment(image)
	    end
    end
	end
end
