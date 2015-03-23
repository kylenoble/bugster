require "webmock/rspec"
require 'devise'
require './spec/support/controller_macros.rb'

# http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

  config.before(:each) do
	  stub_request(:post, "https://3hQ5KCmw.8JL2kfqTqsXufw5PetV11DS:@app.asana.com/api/1.0/tasks").
	         with(:body => "{\"data\":{\"workspace\":11578168261560,\"name\":\"test bug\",\"projects\":[26598858855777],\"assignee\":\"11578171723085\"}}",
	              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
	         to_return(:status => 200, :body => "task_id", :headers => {})
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)
