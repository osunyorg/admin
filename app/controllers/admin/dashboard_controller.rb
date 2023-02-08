class Admin::DashboardController < Admin::ApplicationController
  def index
    @chapters = [
      Education,
      Research,
      Communication,
      Administration
    ]
    breadcrumb
  end
end
