class Admin::Communication::MediasController < Admin::Communication::Medias::ApplicationController
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

  def show
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def pick
    picker = Osuny::Media::Picker.new
    picker.university = current_university
    picker.language = current_language
    picker.params = params.to_unsafe_hash
    render json: picker.to_json
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    if @media.save
      redirect_to [:admin, @media], notice: t('admin.successfully_created_html', model: @media.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
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
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @media.destroy
    redirect_to admin_communication_medias_url, notice: t('admin.successfully_destroyed_html', model: @media.to_s_in(current_language))
  end

  protected

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