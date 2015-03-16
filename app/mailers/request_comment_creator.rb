class RequestCommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_request_comment_notifier_email(comment)
  	@comment = comment
    emails = @comment.request.email.split(',')
    subject = "A comment has been added to: #{@comment.request.title}. Request ##{@comment.request.id}"
    emails.each do |email|
    	mail( :to => email, :subject => 'A Comment has been added to your Request!' ).deliver
    end
  end
end
