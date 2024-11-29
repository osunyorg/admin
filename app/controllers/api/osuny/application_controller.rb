class Api::Osuny::ApplicationController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_app_token

  protected

  def verify_app_token
    @app = current_university.apps.find_by(token: request.headers['X-Osuny-Token'])
    render_unauthorized unless @app
  end
end
