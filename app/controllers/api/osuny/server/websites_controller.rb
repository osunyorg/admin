class Api::Osuny::Server::WebsitesController < Api::ApplicationController

  def index
    @websites = Communication::Website.in_production
  end

  def theme_released
    render_forbidden unless params[:secret_key].present? && params[:secret_key] == ENV['OSUNY_API_AUTOUPDATE_THEME_KEY']
    Communication::Website.with_automatic_update.find_each do |website|
      website.update_theme_version
    end
  end
end
