class Admin::Communication::ApplicationController < Admin::ApplicationController

  def index
    @class_name = Communication
    breadcrumb
    render 'admin/dashboard/part'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human, admin_communication_root_path
    @menu_collapsed = true if @website
  end
end
