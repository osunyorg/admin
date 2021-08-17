class Communication::WebsitesController < ApplicationController
  def index
    @sites = current_university.communication_websites
    add_breadcrumb 'Sites', :communication_websites_path
  end

  def show
    @site = current_university.communication_websites.find(params[id])
    add_breadcrumb @site
  end
end
