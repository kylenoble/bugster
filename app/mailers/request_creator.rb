class RequestCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_request_notifier_email(request)
    @request = request
    emails = @request.email.split(',')
    subject = "Thanks for reporting: #{@request.title}. Request ##{@request.id}"
    emails.each do |email|
    	mail( :to => email, :subject => subject ).deliver
    end
  end
end