class Admin::Communication::DashboardController < Admin::Communication::ApplicationController

  def index
    raise_403_unless feature_communication?
    @namespace = Communication
    @hero_summary = true
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
