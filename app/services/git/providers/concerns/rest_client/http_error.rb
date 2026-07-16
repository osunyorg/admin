# Class to handle generic, raw HTTP errors that can occur when making the REST request
class Git::Providers::Concerns::RestClient::HTTPError < StandardError
  include Git::Providers::Abstract::Error

  def initialize(message = nil, response_status: nil, response_body: nil)
    @response_status = response_status
    @response_body = response_body
    super(message || default_message)
  end

  def self.from_response(response)
    klass = case response.code.to_i
            when 401 then Unauthorized
            when 403 then Forbidden
            when 404 then NotFound
            when 409 then Conflict
            when 422 then UnprocessableEntity
            when 500..599 then ServerError
            else self
            end
    klass.new(
      response_status: response.code.to_i,
      response_body: response.body
    )
  end

  private

  attr_reader :response_status, :response_body

  def default_message
    "REST API error (#{response_status}): #{response_body}"
  end

  class Unauthorized < self
  end

  # Mark 403, 404, 409 and 422 as client errors, so that we can discard them immediately.
  # Not including 401 (unauthorized) as it is handled specifically (invalidate the token).
  # Not including 429 (rate limit) as it worth retrying for the specific case.
  class Forbidden < self
    include Git::Providers::Abstract::ClientError
  end
  class NotFound < self
    include Git::Providers::Abstract::ClientError
  end
  class Conflict < self
    include Git::Providers::Abstract::ClientError
  end
  class UnprocessableEntity < self
    include Git::Providers::Abstract::ClientError
  end
  class ServerError < self; end
end
