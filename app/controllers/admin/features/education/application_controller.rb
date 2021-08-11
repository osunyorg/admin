class Admin::Features::Education::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb I18n.t('features.education.title'), :admin_features_education_dashboard_path
  end
end
