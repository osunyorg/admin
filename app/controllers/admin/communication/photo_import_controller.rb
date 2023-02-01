class Admin::Communication::PhotoImportController < Admin::Communication::ApplicationController
  layout false

  def unsplash
    @query = params[:query]
    @search = []
    @total = 0
    @total_pages = 0
    if @query.present?
      p = {
        query: @query,
        page: (params[:page].presence || 1),
        per_page: (params[:per_page].presence || 10),
        lang: (params[:lang].presence || 'en')
      }
      p[:orientation] = params[:orientation] if params.has_key? :orientation
      @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
      @total = @search.total
      @total_pages = @search.total_pages
    end
  end

  def pexels
    @query = params[:query]
    @search = []
    @total = 0
    @total_pages = 0
    if @query.present?
      p = {
        query: @query,
        page: (params[:page].presence || 1),
        per_page: (params[:per_page].presence || 10),
        lang: (params[:lang].presence || 'en')
      }
      p[:orientation] = params[:orientation] if params.has_key? :orientation
      @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
      @total = @search.total
      @total_pages = @search.total_pages
    end
  end
end
