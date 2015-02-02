class BugCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_bug_notifier_email(bug)
    @bug = bug
    mail( :to => @bug.email, :subject => 'Thanks for finding a Bug!' )
  end
end
