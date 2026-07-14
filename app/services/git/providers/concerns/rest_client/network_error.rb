# Network-level failure (DNS, connection refused, timeout...); distinct from HTTPError,
# which represents a response actually received from the server. Tagged Error: because
# a network failure is transient, so it follows the same generic retry_on.
class Git::Providers::Concerns::RestClient::NetworkError < StandardError
  include Git::Providers::Abstract::Error
end
