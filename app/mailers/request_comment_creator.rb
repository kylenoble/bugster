class RequestCommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_request_comment_notifier_email(comment)
  	@comment = comment
    mail( :to => @comment.request.email, :subject => 'A Comment has been added to your Request!' )
  end
end
