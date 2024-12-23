class Api::Osuny::Communication::WebsitesController < Api::Osuny::ApplicationController
  def index
    @websites = current_university.websites.includes(:localizations)
  end

  def show
    @website = current_university.websites.find params[:id]
  end
end
