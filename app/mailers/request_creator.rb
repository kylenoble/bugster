class RequestCreator < ActionMailer::Base
  default from: "bugster@ignitemedia.com"

  def send_bug_notifier_email(request)
    @request = request
    mail( :to => @request.email, :subject => 'Thanks for adding a request!' )
  end
end