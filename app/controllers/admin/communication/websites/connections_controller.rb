class Admin::Communication::Websites::ConnectionsController < Admin::Communication::Websites::ApplicationController
  def index
    @connections = @website.connections.ordered
    breadcrumb
  end

  def indirect_object
    @indirect_object_type = params[:type]
    @connections = @website.connections
                           .where(indirect_object_type: @indirect_object_type)
                           .order(:direct_source_type, :direct_source_id)
    @indirect_objects = @connections.collect(&:indirect_object).uniq.sort_by(&:to_s)
    breadcrumb
    add_breadcrumb 'Objets indirects'
    add_breadcrumb @indirect_object_type
  end

  def direct_source
    @direct_source_type = params[:type]
    @connections = @website.connections
                           .where(direct_source_type: @direct_source_type)
                           .order(:indirect_object_type, :indirect_object_id)
    @direct_sources = @connections.collect(&:direct_source).uniq.sort_by(&:to_s)
    breadcrumb
    add_breadcrumb 'Sources directes'
    add_breadcrumb @direct_source_type
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