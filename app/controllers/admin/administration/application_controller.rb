class Admin::Administration::ApplicationController < Admin::ApplicationController
 
  protected

  def current_subnav_context
    'navigation/admin/administration'
  end

  def breadcrumb
    super
    add_breadcrumb Administration.model_name.human, admin_administration_root_path
  end
end
