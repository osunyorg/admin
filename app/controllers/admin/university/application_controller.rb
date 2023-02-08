class Admin::University::ApplicationController < Admin::ApplicationController

  def index
    @class_name = University
    breadcrumb
    render 'admin/dashboard/part'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University.model_name.human, admin_university_root_path
  end
end
