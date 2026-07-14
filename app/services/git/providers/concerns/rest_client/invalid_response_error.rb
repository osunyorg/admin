# The server returned a successful HTTP status, but the response body wasn't the valid
# JSON we expected; distinct from HTTPError, which represents a response the server
# explicitly flagged as an error via its status code. Tagged Error: because this can
# still be transient (a proxy returning malformed output, a truncated response...).
class Git::Providers::Concerns::RestClient::InvalidResponseError < StandardError
  include Git::Providers::Abstract::Error
end
