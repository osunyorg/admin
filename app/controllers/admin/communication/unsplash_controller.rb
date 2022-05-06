class Admin::Communication::UnsplashController < Admin::Communication::ApplicationController
  layout false

  def index
    if params[:query].blank?
      @search = []
    else
      @search = Unsplash::Search.search "/search/photos",
        Unsplash::Photo,
        {
          query: params[:query],
          page: (params[:page] || 1),
          per_page: (params[:per_page] || 10),
          orientation: (params[:orientation] || 'squarish'),
          lang: (params[:lang] || 'en')
        }
    end
  end
end
