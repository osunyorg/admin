class Api::Osuny::Communication::WebsitesController < Api::Osuny::Communication::Websites::ApplicationController
  def index
    @websites = websites.ordered(current_language)
  end

  def show
    @website = websites.find params[:id]
  end
end
