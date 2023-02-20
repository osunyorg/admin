class Admin::Research::Hal::ApplicationController < Admin::Research::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Research::Hal.model_name.human, admin_research_hal_root_path
  end

end