class Admin::Education::DashboardController < Admin::Education::ApplicationController

  def index
    @namespace = Education
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
