class Admin::Communication::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Communication.model_name.human, admin_communication_root_path if current_university.is_really_a_university
    @menu_collapsed = true if @website
  end
end
