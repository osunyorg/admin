class Server::DashboardController < Server::ApplicationController
  def index
    @parts = [
      {
        title: "#{University.count} #{University.model_name.human(count: 2).downcase}",
        path: server_universities_path
      },
      {
        title: "#{Communication::Website.count} #{Communication::Website.model_name.human(count: 2).downcase}",
        path: server_websites_path
      }
    ]
    breadcrumb
  end
end
