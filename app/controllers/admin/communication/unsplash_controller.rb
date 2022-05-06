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
        page: (params[:page] || 1),
        per_page: (params[:per_page] || 10),
        orientation: (params[:orientation] || 'squarish'),
        lang: (params[:lang] || 'en')
      }
      @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
      @total = @search.total
      @total_pages = @search.total_pages
    end
  end
end
