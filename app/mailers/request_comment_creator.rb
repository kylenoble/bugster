class RequestCommentCreator < ActionMailer::Base
  default from: "donotreply@bugster.ignite-tek.com"

  def send_request_comment_notifier_email(comment)
  	@comment = comment
  	emails = self.remove_trailing_comma(@comment.request.email)
    emails = emails.split(',')
    subject = "A comment has been added to: #{@comment.request.title}. Request ##{@comment.request.id}"
    emails.each do |email|
    	mail( :to => email, :subject => 'A Comment has been added to your Request!' ).deliver
    end
  end

  def remove_trailing_comma(str)
    str.nil? ? nil : str.chomp(", ")
  end
end
