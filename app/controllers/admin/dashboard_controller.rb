class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = []
    @namespaces << Education if feature_education?
    @namespaces << Research if feature_research?
    @namespaces << Communication if feature_communication?
    @namespaces << Administration if feature_administration?
    # higher priorities are negatives. Default is priority 0
    # FIXME
    @background_tasks_count = 0
    breadcrumb
  end
end
