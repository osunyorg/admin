class Admin::Communication::Websites::ConnectionsController < Admin::Communication::Websites::ApplicationController
  def index
    @connections = @website.connections.ordered
    breadcrumb
  end

  def show
    @connection = @website.connections.find params[:id]
    breadcrumb
    add_breadcrumb @connection
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website::Connection.model_name.human(count: 2), admin_communication_website_connections_path
  end
end