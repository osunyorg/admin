class Admin::Communication::Websites::ConfigsController < Admin::Communication::Websites::ApplicationController
  def index
    breadcrumb
  end

  def show
    @about = @website
    partial = "admin/communication/websites/configs/#{params[:id]}/static"
    render  partial, 
            layout: false, 
            content_type: "text/plain; charset=utf-8"
  end

  protected

  def breadcrumb
    super
    add_breadcrumb 'Configs', admin_communication_website_configs_path
  end

end