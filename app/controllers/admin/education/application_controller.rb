class Admin::Education::ApplicationController < Admin::ApplicationController

  def index
    @namespace = Education
    breadcrumb
    render 'admin/dashboard/namespace'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Education.model_name.human, admin_education_root_path
    @menu_collapsed = true if @program
  end
end
