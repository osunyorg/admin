class Server::WebsitesController < Server::ApplicationController

  def index
    @websites = Communication::Website.all.ordered
    breadcrumb
  end

  def edit
    @website = Communication::Website.find params[:id]
    breadcrumb
    add_breadcrumb @website
  end

  def update
    @website = Communication::Website.find params[:id]
    @website.update_column :theme_version, params[:communication_website][:theme_version]
    redirect_to server_websites_path
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.model_name.human(count: 2), server_websites_path
  end
end