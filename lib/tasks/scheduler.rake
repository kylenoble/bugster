namespace :email_suggestions do

  desc 'Generate email suggestions'
  task index: :environment do
    EmailSuggestion.seed
  end

end