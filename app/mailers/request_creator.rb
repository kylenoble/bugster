class RequestCreator < ActionMailer::Base
  default from: "donotreply@bugster.ignite-tek.com"

  def send_request_notifier_email(request)
    @request = request
    emails = self.remove_trailing_comma(@request.email).split(',').reject { |a| a.strip.length == 0 }
    subject = "Thanks for reporting: #{@request.title}. Request ##{@request.id}"
    emails.each do |email|
    	mail( :to => email, :subject => subject ).deliver
    end
  end

  def remove_trailing_comma(str)
    str.nil? ? nil : str.chomp(", ")
  end
end