class Admin::Communication::Library::FilesController < Admin::Communication::Library::Files::ApplicationController
  load_and_authorize_resource class: Communication::File,
                              through: :current_university

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @filtered = @files.filter_by(params[:filters], current_language)
    @files = @filtered.at_lifecycle(params[:lifecycle], current_language)
                      .order(created_at: :desc)
                      .page(params[:page])
    @categories = categories.root
    breadcrumb
    @feature_nav = 'navigation/admin/communication/files'
  end

  def picker
    @picker = Osuny::Picker::Communication::Library::File.new(
      university: current_university,
      language: current_language,
      params: params
    )
  end

  def show
    respond_to do |format|
      format.html do
        @contexts = @l10n.contexts
        breadcrumb
      end
      format.json do
        @l10n = @file.create_localization_if_missing!(current_language)
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
    # Le blob est sur la localisation, contrairement aux médias
    @l10n = Communication::File::Localization.find_or_create_file_localization_from_blob(
      @blob,
      language: current_language,
      user: current_user
    )
    @file = @l10n.file
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('admin.subnav.settings')
  end

  def create
    @file.created_by = current_user
    if @file.save
      redirect_to [:admin, @file],
                  notice: t('admin.successfully_created_html', model: @file.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @file.update(file_params)
      @file.localization_for(current_language)
           .update_column(:updated_by_id, current_user.id)
      redirect_to [:admin, @file],
                  notice: t('admin.successfully_updated_html', model: @file.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @file.destroy
    redirect_to admin_communication_files_url,
                notice: t('admin.successfully_destroyed_html', model: @file.to_s_in(current_language))
  end

  protected

  def blob_args
    params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
  end

  def file_params
    params.require(:communication_file)
          .permit(
            category_ids: [],
            localizations_attributes: [
              :id, :name, :alt, :credit, :internal_description, :meta_description, :published,
              :original_uploaded_file, :language_id
            ]
          )
          .merge(university_id: current_university.id)
  end

  def categories
    current_university.communication_file_categories.ordered
  end

end
