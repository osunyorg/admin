class Admin::Communication::Library::MediasController < Admin::Communication::Library::Medias::ApplicationController
  load_and_authorize_resource class: Communication::Media,
                              through: :current_university

  include Admin::Localizable

  def index
    @medias = @medias.filter_by(params[:filters], current_language)
                      .ordered(current_language)
                      .page(params[:page])
    @collections = current_university.communication_media_collections
                                     .ordered(current_language)
    @categories = categories.root
    breadcrumb
    @feature_nav = 'navigation/admin/communication/medias'
  end

  def picker
    @picker = Osuny::Picker::Communication::Library::Media.new(
      university: current_university,
      language: current_language,
      params: params
    )
  end

  def show
    @contexts = @media.contexts
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def direct_upload
    @blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)
    @blob.update_column(:university_id, current_university&.id)
    # Le blob est sur le média
    @media = Communication::Media.find_or_create_from_blob(@blob, user: current_user)
    @media.find_or_create_localization(current_language)
  end

  def set_featured
    @media = current_university.communication_medias
                               .find(params[:media])
    # FIXME
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university
    )
    @about.featured_media = @media
    @about.save
    render :ok
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    @media.created_by = current_user
    if @media.save
      redirect_to [:admin, @media], notice: t('admin.successfully_created_html', model: @media.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @media.update(media_params)
      redirect_to [:admin, @media], notice: t('admin.successfully_updated_html', model: @media.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @media.destroy
    redirect_to admin_communication_medias_url, notice: t('admin.successfully_destroyed_html', model: @media.to_s_in(current_language))
  end

  protected

  def blob_args
    params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
  end

  def media_params
    params.require(:communication_media)
          .permit(
            :communication_media_collection_id, :original_uploaded_file, category_ids: [],
            localizations_attributes: [
              :id, :name, :alt, :credit, :internal_description, :language_id
            ]
          )
          .merge(university_id: current_university.id)
  end

  def categories
    current_university.communication_media_categories.ordered
  end

end