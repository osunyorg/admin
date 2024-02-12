class Server::DashboardController < Server::ApplicationController

  def index
    @parts = [
      {
        title: "#{University.count} #{University.model_name.human(count: University.count).downcase}",
        path: server_universities_path
      },
      {
        title: "#{Communication::Website.count} #{Communication::Website.model_name.human(count: Communication::Website.count).downcase}",
        path: server_websites_path
      }
    ]
    @websites = Communication::Website.with_url.for_older_theme_version(Osuny::ThemeInfo.get_current_version).ordered
    breadcrumb
  end
  
end
