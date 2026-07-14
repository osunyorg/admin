# Utility module to be used by providers accessible by a REST API and without a dedicated client ruby gem
# Include this module in a concrete provider and implement 'request_headers'
# See forgejo provider for an example of usage
module Git::Providers::Concerns::RestClient
  # GET request with JSON response. Raises HTTPError on any non-2xx status, NetworkError
  # on a network-level failure, or InvalidResponseError if the response is not valid JSON.
  def get(path, params = {})
    response = get_raw(path, params)
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    raise Git::Providers::Concerns::RestClient::InvalidResponseError, "Invalid JSON response from #{path}: #{e.message}"
  end

  # Raw GET request. Returns the full Net::HTTPResponse object on success, raises
  # HTTPError on any non-2xx status, or NetworkError on a network-level failure.
  def get_raw(path, params = {})
    uri = build_uri(path, params)
    response = http(uri).get(uri.request_uri, request_headers)
    raise Git::Providers::Concerns::RestClient::HTTPError.from_response(response) unless response.is_a?(Net::HTTPSuccess)
    response
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, Timeout::Error, EOFError => e
    raise Git::Providers::Concerns::RestClient::NetworkError, e.message
  end

  # Strict write request (POST, PUT, DELETE): raises HTTPError unless the response is a
  # 2xx success, or NetworkError on a network-level failure.
  def rest_request(method, path, payload)
    uri = build_uri(path)
    klass = { post: Net::HTTP::Post, put: Net::HTTP::Put, delete: Net::HTTP::Delete }.fetch(method)
    req = klass.new(uri.request_uri, request_headers)
    req.body = payload.to_json
    response = http(uri).request(req)
    raise Git::Providers::Concerns::RestClient::HTTPError.from_response(response) unless response.is_a?(Net::HTTPSuccess)
    response
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, Timeout::Error, EOFError => e
    raise Git::Providers::Concerns::RestClient::NetworkError, e.message
  end

  # Build the full URI to call (endpoint base + relative path)
  # and optional query string parameters.
  def build_uri(path, params = {})
    base = endpoint.delete_suffix('/')
    uri = URI.parse("#{base}#{path}")
    uri.query = URI.encode_www_form(params) if params.present?
    uri
  end

  # Creates the Net::HTTP client for a specified URI (with SSL if necessary).
  def http(uri)
    client = Net::HTTP.new(uri.host, uri.port)
    client.use_ssl = uri.scheme == 'https'
    client
  end
end