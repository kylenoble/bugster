class CommentCreator < ActionMailer::Base
  default from: "donotreply@bugster.ignite-tek.com"

  def send_comment_notifier_email(comment)
  	@comment = comment
  	emails = self.remove_trailing_comma(@comment.bug.email).split(',').reject { |a| a.strip.length == 0 }
    subject = "A comment has been added to: #{@comment.bug.title}. Ticket ##{@comment.bug.id}"
    emails.each do |email|
    	mail( :to => email, :subject => subject ).deliver
    end
  end

  def remove_trailing_comma(str)
    str.nil? ? nil : str.chomp(", ")
  end
end
