class Admin::Research::ApplicationController < Admin::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb Research.model_name.human
  end
end
