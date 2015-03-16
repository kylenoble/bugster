class CommentCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_comment_notifier_email(comment)
  	@comment = comment
    emails = @comment.bug.email.split(',')
    subject = "A comment has been added to: #{@comment.bug.title}. Ticket ##{@comment.bug.id}"
    emails.each do |email|
    	mail( :to => email, :subject => subject ).deliver
    end
  end
end
