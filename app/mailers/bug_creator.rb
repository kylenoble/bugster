class BugCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_bug_notifier_email(bug)
    @bug = bug
    emails = @bug.email.split(',')
    subject = "Thanks for reporting: #{@bug.title}. Ticket ##{@bug.id}"
    emails.each do |email|
    	if @bug.priority == "Outage"
    		mail( :to => email, :subject => "OUTAGE-- Thanks for Reporting An Outage. #{@bug.title}. Ticket ##{@bug.id}" ).deliver
    	else
    		mail( :to => email, :subject => subject).deliver
    	end	
    end
  end
end
