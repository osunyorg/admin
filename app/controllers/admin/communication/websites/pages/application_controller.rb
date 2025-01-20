class Admin::Communication::Websites::Pages::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  t('admin.communication.website.subnav.structure'),
                    admin_communication_website_pages_path
  end
end
