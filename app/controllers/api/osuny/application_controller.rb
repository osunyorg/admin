class Api::Osuny::ApplicationController < Api::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_app_token

  protected

  def verify_app_token
    @app = current_university.apps.find_by(token: request.headers['X-Osuny-Token'])
    raise_403_unless @app
  end
end
