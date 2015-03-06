class RequestCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_request_notifier_email(request)
    @request = request
    emails = @request.email.split(',')
    emails.each do |email|
    	mail( :to => email, :subject => 'Thanks for finding a Bug!' ).deliver
    end
  end
end