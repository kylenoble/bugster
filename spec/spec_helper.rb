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
    stub_request(:any, /app.asana.com/).to_rack(FakeAsana)
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)
