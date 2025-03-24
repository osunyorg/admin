Octokit.middleware = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: true, store: Rails.cache
  builder.use Faraday::Retry::Middleware, exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Octokit::ServerError]
  builder.use Octokit::Middleware::FollowRedirects
  builder.use Octokit::Response::RaiseError
  builder.use Octokit::Response::FeedParser
  builder.adapter Faraday.default_adapter
  if Rails.env.development?
    # Enable logging in development environment
    # https://github.com/octokit/octokit.rb?tab=readme-ov-file#debugging
    octokit_logger = ActiveSupport::TaggedLogging.logger(STDOUT).tagged("Octokit")
    builder.response :logger, octokit_logger do |logger|
      logger.filter(/(Authorization: "(token|Bearer) )(\w+)/, '\1[REMOVED]')
    end
  end
end
