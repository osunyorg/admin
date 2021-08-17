class Server::DashboardController < Server::ApplicationController
  def index
    @universities = University.all.ordered
    breadcrumb
  end
end
