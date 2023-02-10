class Admin::Research::ApplicationController < Admin::ApplicationController

  def index
    @namespace = Research
    breadcrumb
    render 'admin/dashboard/namespace'
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human, admin_research_root_path
    @menu_collapsed = true if @journal || @laboratory
  end
end
