class Server::WebsitesController < Server::ApplicationController

  has_scope :for_theme_version
  has_scope :for_production
  has_scope :for_search_term

  def index
    @websites = apply_scopes(Communication::Website.all).ordered
    breadcrumb
    add_breadcrumb Communication::Website.model_name.human(count: 2), server_websites_path
  end

  def refresh
    @website = Communication::Website.find params[:id]
    @website.get_current_theme_version!
  end

end
