class CommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_comment_notifier_email(comment)
  	@comment = comment
    mail( :to => @comment.bug.email, :subject => 'A Comment has been added to your Bug!' )
  end
end
