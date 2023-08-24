class Api::Osuny::Server::WebsitesController < Api::ApplicationController

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
