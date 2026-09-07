class Admin::Communication::Library::Medias::PhotoImportsController < Admin::Communication::ApplicationController
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
    begin
      @search = Unsplash::Search.search "/search/photos", Unsplash::Photo, p
      @total = @search.total
      @total_pages = @search.total_pages
    rescue Unsplash::Error => e
      @search = []
      @total = 0
      @total_pages = 1
    end
  end

  def pexels
    return if @query.blank?
    begin
      @search = Pexels::Client.new.photos.search(@query, page: @page, per_page: @per_page)
      @total = @search.total_results
      @total_pages = @search.total_pages
    rescue Pexels::APIError => e
      @search = []
      @total = 0
      @total_pages = 1
    end
  end

  def select
    origin = params[:origin]

    if origin == 'unsplash'
      # https://images.unsplash.com/photo-1740393068492-53e82b121535?crop=...
      # => photo-1740393068492-53e82b121535.jpeg
      filename = URI.parse(params[:source]).path.split('/').last.to_s + ".jpeg"
    end

    @media = Communication::Media.find_or_create_from_url(
      params[:source],
      filename: filename,
      university_id: current_university.id,
      user: current_user,
      origin: origin
    )
    @media.find_or_create_localization(current_language, credit: params[:credit])

    if origin == 'unsplash'
      # Tracking légal Unsplash
      unsplash_photo = Unsplash::Photo.find(params[:id])
      unsplash_photo.track_download
    end

    render json: @media.id
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
