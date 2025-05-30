class Api::Osuny::ApplicationController < Api::ApplicationController
  include WithResourceParams

  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActionController::BadRequest, with: :handle_bad_request

  skip_before_action :verify_authenticity_token
  before_action :verify_app_token

  protected

  def verify_app_token
    @app = current_university.apps.find_by(token: request.headers['X-Osuny-Token'])
    render_unauthorized unless @app
  end

  def render_on_missing_migration_identifier
    render json: { error: 'Missing migration identifier.' }, status: :bad_request
  end

  # Set API messages to English
  def switch_locale(&action)
    I18n.with_locale(:en, &action)
  end

  def handle_bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
