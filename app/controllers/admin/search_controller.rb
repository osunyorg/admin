class Admin::SearchController < Admin::ApplicationController
  def index
    @term = params[:term]
    @results = @term.present? ? search_results : Search.none
    render layout: false
  end

  protected

  def search_results
    results = current_university.search.for_title(@term).in(current_language).limit(30)
    results = results.where(website_id: params[:website_id]) if params.has_key?(:website_id)
    results = results.where(extranet_id: params[:extranet_id]) if params.has_key?(:extranet_id)
    results
  end

  def default_url_options
    options = super
    options[:website_id] = params[:website_id] if params.has_key?(:website_id)
    options[:extranet_id] = params[:extranet_id] if params.has_key?(:extranet_id)
    options
  end
end