class Admin::University::DashboardController < Admin::University::ApplicationController

  def index
    raise_403_unless can?(:read, University::Person) || can?(:read, University::Organization) || can?(:read, User)
    @namespace = University
    breadcrumb
    render 'admin/dashboard/namespace'
  end

end
