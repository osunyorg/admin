class Admin::Communication::Websites::Jobboard::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  @website.feature_jobboard_name(current_language), 
                    admin_communication_website_jobboard_jobs_path
  end
end
