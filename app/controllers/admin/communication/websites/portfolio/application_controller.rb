class Admin::Communication::Websites::Portfolio::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Portfolio.model_name.human(count: 2), 
                    admin_communication_website_portfolio_projects_path
  end
end
