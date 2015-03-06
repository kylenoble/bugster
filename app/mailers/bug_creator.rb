class BugCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_bug_notifier_email(bug)
    @bug = bug
    emails = @bug.email.split(',')
    emails.each do |email|
    	mail( :to => email, :subject => 'Thanks for finding a Bug!' )
    end
  end
end
