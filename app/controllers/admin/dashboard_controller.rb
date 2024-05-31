class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = []
    @namespaces << Education if feature_education?
    @namespaces << Research if feature_research?
    @namespaces << Communication if feature_communication?
    @namespaces << Administration if feature_administration?
    @background_tasks_count = GoodJob::Job.running.count + GoodJob::Job.queued.count + GoodJob::Job.retried.count
    breadcrumb
  end
end
