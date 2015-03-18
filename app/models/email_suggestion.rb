class EmailSuggestion
	def self.seed
    Bug.find_each do |bug|
      emails = bug.email.split(',')
      org = bug.org
      emails.each do |email|
      	1.upto(email.length - 1) do |n|
        	prefix = email[0, n]
        	$redis.zadd "email-suggestions-#{org}:#{prefix.downcase}", 1, email.downcase
        end
      end
    end
    Request.find_each do |request|
      emails = request.email.split(',')
      org = request.org
      emails.each do |email|
      	1.upto(email.length - 1) do |n|
        	prefix = email[0, n]
        	$redis.zadd "email-suggestions-#{org}:#{prefix.downcase}", 1, email.downcase
        end
      end
    end
  end

  def self.terms_for(prefix, org)
    puts "email-suggestions-#{org}:#{prefix.downcase}"
    $redis.zrevrange "email-suggestions-#{org}:#{prefix.downcase}", 0, 9
  end
end