# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron


set :output, {:error => './log/error.log', :standard => './log/cron.log'}

every 2.hours do
	rake "email_suggestions:index"
end
