class Admin::Communication::UnsplashController < Admin::Communication::ApplicationController
  layout false

  def index
    if params[:query].blank?
      @search = []
      @total = 0
      @total_pages = 0
    else
      p = {
        query: params[:query],
        page: (params[:page].presence || 1),
        per_page: (params[:per_page].presence || 10),
        orientation: (params[:orientation].presence || 'squarish'),
        lang: (params[:lang].presence || 'en')
      }
      @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
      @total = @search.total
      @total_pages = @search.total_pages
    end
  end
end
