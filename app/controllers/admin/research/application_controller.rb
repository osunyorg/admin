class Admin::Research::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human, admin_research_root_path
    @menu_collapsed = true if @journal || @laboratory
  end
end
