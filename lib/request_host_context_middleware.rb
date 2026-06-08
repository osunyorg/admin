class RequestHostContextMiddleware
  THREAD_REGISTRATION_CONTEXT_HOST_KEY = :osuny_registration_context_host

  def initialize(app)
    @app = app
  end

  def call(env)
    Thread.current[THREAD_REGISTRATION_CONTEXT_HOST_KEY] = Rack::Request.new(env).host
    @app.call(env)
  ensure
    Thread.current[THREAD_REGISTRATION_CONTEXT_HOST_KEY] = nil
  end
end
