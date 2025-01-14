class Admin::Communication::Websites::Posts::ApplicationController < Admin::Communication::Websites::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb  @website.feature_posts_name(current_language),
                    admin_communication_website_posts_path
  end
end
