class Admin::Communication::UnsplashController < Admin::Communication::ApplicationController
  layout false

  def index
    if params[:query].blank?
      @photos = []
    else
      @photos = Unsplash::Search.search "/search/photos",
        Unsplash::Photo,
        {
          query: params[:query],
          page: (params[:page] || 1),
          per_page: (params[:per_page] || 18),
          orientation: (params[:orientation] || 'squarish'),
          lang: (params[:lang] || 'en')
        }
    end
  end
end
