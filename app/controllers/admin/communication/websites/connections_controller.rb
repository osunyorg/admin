class Admin::Communication::Websites::ConnectionsController < Admin::Communication::Websites::ApplicationController
  before_action :load_object, except: :index

  def index
    @connections = @website.connections.page params[:page]
  end

  def create
    @website.connect @object
    head :ok
  end
  
  def destroy
    @website.disconnect @object
    redirect_back(fallback_location: [:admin, @object])
  end

  protected

  def load_object
    object_type = params[:object_type]
    object_id = params[:object_id]
    @object = object_type.constantize.find object_id
  end
end