class Admin::Communication::UnsplashController < Admin::Communication::ApplicationController
  layout false

  def index
    @search = params[:search]
    @quantity = params[:quantity] || 18
    @photos = @search ? Unsplash::Photo.search(@search, 1, @quantity, :squarish)
                      : []
  end
end
