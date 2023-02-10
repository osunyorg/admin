class Admin::Administration::ApplicationController < Admin::ApplicationController
 
  def index
    @namespace = Administration
    breadcrumb
    render 'admin/dashboard/namespace'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Administration.model_name.human, admin_administration_root_path
  end
end
