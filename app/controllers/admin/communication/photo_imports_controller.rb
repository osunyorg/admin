class Admin::Communication::PhotoImportsController < Admin::Communication::ApplicationController
  layout false
  before_action :prepare

  def unsplash
    return if @query.blank?
    p = {
      query: @query,
      page: @page,
      per_page: @per_page,
      lang: @lang
    }
    p[:orientation] = params[:orientation] if params.has_key? :orientation
    @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
    @total = @search.total
    @total_pages = @search.total_pages
  end

  def pexels
    return if @query.blank?
    @search = Pexels::Client.new.photos.search(@query, page: @page, per_page: @per_page)
    @total = @search.total_results
    @total_pages = @search.total_pages
  end

  protected

  def prepare
    @query = "#{params[:query]}"
    @page = params[:page].presence || 1
    @per_page = params[:per_page].presence || 12
    @lang = params[:lang].presence || 'en'
    @search = []
    @total = 0
    @total_pages = 0
  end
end
