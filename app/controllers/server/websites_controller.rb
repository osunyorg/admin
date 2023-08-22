class Server::WebsitesController < Server::ApplicationController
  before_action :load_website, only: [:sync_theme_version, :update_theme]

  has_scope :for_theme_version
  has_scope :for_production
  has_scope :for_update
  has_scope :for_search_term

  def index
    @websites = apply_scopes(Communication::Website.all).ordered
    breadcrumb
    add_breadcrumb Communication::Website.model_name.human(count: 2), server_websites_path
  end

  def sync_theme_version
    @website.get_current_theme_version!
  end

  def update_theme
    @website.update_theme_version
  end

  protected

  def load_website
    @website = Communication::Website.find params[:id]
  end
end
