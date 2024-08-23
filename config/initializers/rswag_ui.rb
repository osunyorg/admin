Rswag::Ui.configure do |c|

  # List the Swagger endpoints that you want to be documented through the
  # swagger-ui. The first parameter is the path (absolute or relative to the UI
  # host) to the corresponding endpoint and the second is a title that will be
  # displayed in the document selector.
  # NOTE: If you're using rspec-api to expose Swagger files
  # (under openapi_root) as JSON or YAML endpoints, then the list below should
  # correspond to the relative paths for those endpoints.

  c.openapi_endpoint '/api/docs/osuny/v1/openapi.json', 'Osuny API V1 Docs'

  # Add Basic Auth in case your API is private
  # c.basic_auth_enabled = true
  # c.basic_auth_credentials 'username', 'password'
end

# TODO: Waiting for a fix in rswag-ui gem, using this workaround
module Rswag
  module Ui
    class Middleware
      # Redefine the call method
      def call(env)
        if base_path?(env)
          redirect_uri = env['SCRIPT_NAME'].chomp('/') + '/index.html'
          return [ 301, { 'Location' => redirect_uri }, [ ] ]
        end

        if index_path?(env)
          return [ 200, { 'Content-Type' => 'text/html', 'content-security-policy' => csp }, [ render_template ] ]
        end

        super
      end
    end
  end
end