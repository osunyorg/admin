class Admin::Communication::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human, admin_communication_root_path
    @menu_collapsed = true if @website
  end
end
