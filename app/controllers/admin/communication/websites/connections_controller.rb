class Admin::Communication::Websites::ConnectionsController < Admin::Communication::Websites::ApplicationController
  before_action :load_from_object, only: [:create, :destroy]

  def index
    @connections = @website.connections.ordered.page params[:page]
    breadcrumb
  end

  def show
    @connection = @website.connections.find params[:id]
    @others = @connection.for_same_object
    breadcrumb
    add_breadcrumb @connection
  end

  # Strange use of create, does not really create a connection
  def create
    @website.connect @object, @website
    head :ok
  end
  
  # Strange use of destroy, does not really create a connection
  def destroy
    @website.disconnect @object, @website
    redirect_back(fallback_location: [:admin, @object])
  end

  protected

  def load_from_object
    object_type = params[:object_type]
    object_id = params[:object_id]
    @object = object_type.constantize.find object_id
  end

  def breadcrumb
    super
    add_breadcrumb Communication::Website::Connection.model_name.human(count: 2), admin_communication_website_connections_path
  end
end