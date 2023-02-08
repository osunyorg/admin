class Admin::Administration::ApplicationController < Admin::ApplicationController
 
  def index
    @class_name = Administration
    breadcrumb
    render 'admin/dashboard/part'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Administration.model_name.human, admin_administration_root_path
  end
end
