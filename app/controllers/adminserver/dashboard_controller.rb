class Adminserver::DashboardController < Adminserver::ApplicationController
  def index
    @universities = University.all.ordered
    breadcrumb
  end
end
