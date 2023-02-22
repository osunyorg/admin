class Admin::University::DashboardController < Admin::University::ApplicationController

  def index
    @namespace = University
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
