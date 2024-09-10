class Api::Osuny::Server::WebsitesController < Api::Osuny::ApplicationController
  skip_before_action :verify_app_token
  before_action :verify_autoupdate_theme_key

  def theme_released
    Communication::Website.autoupdate_websites
  end

  def verify_autoupdate_theme_key
    render_forbidden if params[:secret_key].blank?
    render_forbidden if params[:secret_key] != ENV['OSUNY_API_AUTOUPDATE_THEME_KEY']
  end
end
