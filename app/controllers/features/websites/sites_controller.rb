class Features::Websites::SitesController < ApplicationController
  def index
    @sites = current_university.features_websites_sites
    add_breadcrumb 'Sites', :features_websites_sites_path
  end

  def show
    @site = current_university.features_websites_sites.find(params[id])
    add_breadcrumb @site
  end
end
