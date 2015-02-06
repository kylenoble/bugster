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
    req.body = request_body.to_json()

    # issue the request
    @res = @http.start { |http| @http.request(req) }
    return @res
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