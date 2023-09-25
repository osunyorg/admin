class Api::Osuny::Server::WebsitesController < Api::Osuny::ApplicationController
  skip_before_action :verify_authenticity_token, only: [:theme_released]

  def index
    @websites = Communication::Website.in_production
  end

  def theme_released
    if params[:secret_key].present? && params[:secret_key] == ENV['OSUNY_API_AUTOUPDATE_THEME_KEY']
      Communication::Website.autoupdate_websites
    else
      render_forbidden 
    end
  end
end
