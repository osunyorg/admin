class Admin::Communication::DashboardController < Admin::Communication::ApplicationController

  def index
    raise_403_unless feature_communication?
    @namespace = Communication
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
