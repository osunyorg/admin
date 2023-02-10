class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = [
      Education,
      Research,
      Communication,
      Administration
    ]
    breadcrumb
  end
end
