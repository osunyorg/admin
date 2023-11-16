class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = []
    @namespaces << Education if feature_education?
    @namespaces << Research if feature_research?
    @namespaces << Communication if feature_communication?
    @namespaces << Administration if feature_administration?
    @background_tasks_count = Delayed::Job.where.not(queue: 'cleanup').length
    breadcrumb
  end
end
