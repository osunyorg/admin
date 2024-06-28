class Admin::DashboardController < Admin::ApplicationController
  def index
    @namespaces = []
    @namespaces << Education if feature_education?
    @namespaces << Research if feature_research?
    @namespaces << Communication if feature_communication?
    @namespaces << Administration if feature_administration?
    breadcrumb
  end

  # called from /admin without any language specified
  def redirect_to_default_language
    redirect_to admin_root_with_lang_path(lang: current_university.default_language)
  end

end
