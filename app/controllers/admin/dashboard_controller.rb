class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = []
    @namespaces << Education if helpers.feature_education?
    @namespaces << Research if helpers.feature_research?
    @namespaces << Communication if helpers.feature_communication?
    @namespaces << Administration if helpers.feature_administration?
    breadcrumb
  end
end
