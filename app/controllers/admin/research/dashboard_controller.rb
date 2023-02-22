class Admin::Research::DashboardController < Admin::Research::ApplicationController

  def index
    @namespace = Research
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
