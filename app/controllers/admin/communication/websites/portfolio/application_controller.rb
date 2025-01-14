class Admin::Communication::Websites::Portfolio::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  @website.feature_portfolio_name(current_language), 
                    admin_communication_website_portfolio_projects_path
  end
end
