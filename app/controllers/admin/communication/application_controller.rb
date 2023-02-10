class Admin::Communication::ApplicationController < Admin::ApplicationController

  def index
    @namespace = Communication
    breadcrumb
    render 'admin/dashboard/namespace'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human, admin_communication_root_path
    @menu_collapsed = true if @website
  end
end
