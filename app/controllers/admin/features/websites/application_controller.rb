class Admin::Features::Websites::ApplicationController < Admin::ApplicationController
  def breadcrumb
    super
    add_breadcrumb Features::Websites.model_name.human, :admin_features_websites_dashboard_path
  end
end
