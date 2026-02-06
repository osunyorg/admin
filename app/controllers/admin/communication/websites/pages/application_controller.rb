class Admin::Communication::Websites::Pages::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Page.model_name.human(count: 2),
                    admin_communication_website_pages_path
  end
end
