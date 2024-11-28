class Admin::Communication::Websites::ConfigsController < Admin::Communication::Websites::ApplicationController
  def index
    breadcrumb
  end

  def show
    unless params[:id].to_sym.in?(Communication::Website.config_files)
      render_not_found 
      return
    end
    @about = @website
    partial = "admin/communication/websites/configs/#{params[:id]}/static"
    render  partial, 
            layout: false, 
            content_type: "text/plain; charset=utf-8"
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Website.human_attribute_name(:configs), admin_communication_website_configs_path
  end

end