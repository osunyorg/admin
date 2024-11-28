class Admin::Communication::Websites::ConfigsController < Admin::Communication::Websites::ApplicationController
  before_action :check_route, only: :show

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

  def check_route
    render_not_found unless route_authorized?
  end

  def route_authorized?
    params[:id].to_sym.in?(Communication::Website.config_files)
  end

  def breadcrumb
    super
    add_breadcrumb Communication::Website.human_attribute_name(:configs), admin_communication_website_configs_path
  end

end