class Admin::Communication::UnsplashController < Admin::Communication::ApplicationController
  layout false

  def index
    @search = params[:search]
    @photos = @search ? Unsplash::Photo.search(@search, 1, 18, :squarish)
                      : []
  end
end
