class Admin::Features::Education::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb Features::Education.model_name.human, :admin_features_education_dashboard_path
  end
end
