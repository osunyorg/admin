class Admin::Education::ApplicationController < Admin::ApplicationController

  protected

  def current_subnav_context
    'navigation/admin/education'
  end

  def breadcrumb
    super
    add_breadcrumb Education.model_name.human, admin_education_root_path
    @menu_collapsed = true if @program
  end
end
