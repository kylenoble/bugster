class AsanaRequest
  def initialize(endpoint)
    @api_key = ENV["ASANA_API_KEY"]
    @uri = URI.parse(endpoint)
    set_http
  end

  def set_http
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
    @http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  end

  def post_response(request_body)
    header = {
      "Content-Type" => "application/json"
    }
    req = Net::HTTP::Post.new(@uri.path, header)
    req.basic_auth(@api_key, '')
    puts request_body
    req.body = request_body.to_json()

    # issue the request
    @res = @http.start { |http| @http.request(req) }
    return @res
  end

  def post_attachment_response(file_type, file)
    connection = Faraday.new(:url => @uri) do |conn|
      conn.response :logger                  # log requests to STDOUT
      conn.request :multipart
      conn.request :url_encoded
      conn.basic_auth(@api_key, '')
      conn.adapter :net_http  # make requests with Net::HTTP
    end

    payload = { :file => Faraday::UploadIO.new(file, file_type) }
    response = connection.post(@uri, payload)
    return response 
  end

  def get_response(request_body)
    header = {
      "Content-Type" => "application/json"
    }
    req = Net::HTTP::Get.new(@uri.path, header)
    req.basic_auth(@api_key, '')
    req.body = request_body.to_json()

    # issue the request
    @res = @http.start { |http| @http.request(req) }
    return @res
  end
end