class Admin::Research::Hal::DashboardController < Admin::Research::Hal::ApplicationController
  def index
    @namespace = Research::Hal
    breadcrumb
    render 'admin/dashboard/namespace'
  end
end
