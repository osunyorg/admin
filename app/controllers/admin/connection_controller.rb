class Admin::ConnectionController < Admin::ApplicationController
  before_action :load_data

  def connect
    @object.connect @dependency
    head :ok
  end
  
  def disconnect
    @object.disconnect @dependency
    redirect_back(fallback_location: [:admin, @object])
  end

  protected

  def load_data
    @object_type = params[:object_type]
    @object_id = params[:object_id]
    @object = @object_type.constantize.find @object_id
    # TODO vérifier l'université
    @dependency_type = params[:dependency_type]
    @dependency_id = params[:dependency_id]
    @dependency = @dependency_type.constantize.find @dependency_id
    # TODO vérifier l'université
  end
end