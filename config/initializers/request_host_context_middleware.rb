require Rails.root.join("lib/request_host_context_middleware")

Rails.application.config.middleware.insert_before Warden::Manager, RequestHostContextMiddleware
