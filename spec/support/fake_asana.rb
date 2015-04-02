require 'sinatra/base'

class FakeAsana < Sinatra::Base
  post '/api/1.0/tasks' do
    json_response 200, 'new_task.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end