class Api::Osuny::ApplicationController < Api::ApplicationController
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
end
