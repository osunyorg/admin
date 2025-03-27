class Api::Osuny::Communication::WebsitesController < Api::Osuny::ApplicationController
  before_action :load_website, only: [:show, :sync]

  def index
    @websites = current_university.websites.includes(:localizations)
  end

  def show
  end

  def sync
    @website.sync_with_git
    head :ok
  end

  protected

  def load_website
    @website = current_university.websites.find(params[:id])
  end
end
