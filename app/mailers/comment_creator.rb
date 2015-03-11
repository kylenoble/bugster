class CommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_comment_notifier_email(comment)
  	@comment = comment
    emails = @comment.bug.email.split(',')
    emails.each do |email|
    	mail( :to => email, :subject => 'A Comment has been added to your Support Ticket!' ).deliver
    end
  end
end
