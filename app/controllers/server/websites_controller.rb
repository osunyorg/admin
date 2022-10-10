class Server::WebsitesController < Server::ApplicationController

  def index
    @websites = Communication::Website.all.ordered
    breadcrumb
  end

end