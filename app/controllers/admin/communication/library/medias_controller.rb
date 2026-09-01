class Admin::Communication::Library::MediasController < Admin::Communication::Library::Medias::ApplicationController
  load_and_authorize_resource class: Communication::Media,
                              through: :current_university

  include Admin::Localizable

  def index
    @filtered = @medias.filter_by(params[:filters], current_language)
    @medias = @filtered.at_lifecycle(params[:lifecycle], current_language)
                       .order(created_at: :desc)
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
    respond_to do |format|
      format.html do
        @contexts = @media.contexts
        breadcrumb
      end
      format.json do
        @l10n = @media.find_or_create_localization(current_language)
        context_about_gid = params.dig(:context_about_gid)
        if context_about_gid.present?
          context_about = GlobalID::Locator.locate(context_about_gid)
          @context = @media.context_for(context_about)
        end
      end
    end
  end

  def new
    @categories = categories
    breadcrumb
  end

  def direct_upload
    @blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)
    @blob.update_column(:university_id, current_university&.id)
    # Le blob est sur le média, pas sur la loca (contrairement aux files)
    @media = Communication::Media.find_or_create_media_from_blob(@blob, user: current_user)
    @l10n = @media.find_or_create_localization(current_language)
  end

  def set_featured
    @l10n = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university
    )
    return if @l10n.nil?
    raise unless can?(:update, @l10n.about)
    @media = @l10n.set_featured_media!(
      id: params.dig(:featured_media_id),
      alt: params.dig(:featured_media_alt),
      crop_settings: params.dig(:crop_settings)&.to_unsafe_hash,
      language: current_language
    )
    @context = @media&.context_for(@l10n)
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    @media.created_by = current_user
    if @media.save
      redirect_to [:admin, @media],
                  notice: t('admin.successfully_created_html', model: @media.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @media.update(media_params)
      @media.localization_for(current_language)
            .update_column(:updated_by_id, current_user.id)
      redirect_to [:admin, @media],
                  notice: t('admin.successfully_updated_html', model: @media.to_s_in(current_language))
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
    redirect_to admin_communication_medias_url,
                notice: t('admin.successfully_destroyed_html', model: @media.to_s_in(current_language))
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
              :id, :name, :alt, :credit, :internal_description, :language_id, :published,
            ]
          )
          .merge(university_id: current_university.id)
  end

  def categories
    current_university.communication_media_categories.ordered
  end

end