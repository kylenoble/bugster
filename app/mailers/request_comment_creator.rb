class RequestCommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_request_comment_notifier_email(comment)
  	@comment = comment
    emails = @comment.request.email.split(',')
    emails.each do |email|
    	mail( :to => email, :subject => 'A Comment has been added to your Request!' )
    end
  end
end
