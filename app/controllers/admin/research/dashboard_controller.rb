class Admin::Research::DashboardController < Admin::Research::ApplicationController

  def index
    raise_403_unless feature_research?
    @namespace = Research
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
