class Admin::Communication::Library::FilesController < Admin::Communication::Library::Files::ApplicationController
  load_and_authorize_resource class: Communication::File,
                              through: :current_university

  include Admin::Localizable

  def index
    @files = @files.filter_by(params[:filters], current_language)
                   .ordered(current_language)
                   .page(params[:page])
    @categories = categories.root
    breadcrumb
    @feature_nav = 'navigation/admin/communication/files'
  end

  def show
    @contexts = @l10n.contexts
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end
  
  def direct_upload
    # TODO factorize this with ActiveStorage::DirectUploadsController#create
    blob_args = params.require(:blob).permit(:filename, :byte_size, :checksum, :content_type, metadata: {}).to_h.symbolize_keys
    @blob = ActiveStorage::Blob.create_before_direct_upload!(**blob_args)
    @blob.update_column(:university_id, current_university&.id)
    # TODO faut-il l'id ou l'iso ?
    @language = Language.find(params[:language])
    @localization = Communication::File::Localization.create_from_blob(@blob, @language)
    @file = @localization.file
  end

  def pick
    picker = Osuny::File::Picker.new
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
    if @file.save
      redirect_to [:admin, @file], notice: t('admin.successfully_created_html', model: @file.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @file.update(file_params)
      redirect_to [:admin, @file], notice: t('admin.successfully_updated_html', model: @file.to_s_in(current_language))
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
    redirect_to admin_communication_files_url, notice: t('admin.successfully_destroyed_html', model: @file.to_s_in(current_language))
  end

  protected

  def file_params
    params.require(:communication_file)
          .permit(
            category_ids: [],
            localizations_attributes: [
              :id, :name, :alt, :credit, :internal_description,
              :original_uploaded_file, :language_id
            ]
          )
          .merge(university_id: current_university.id)
  end

  def categories
    current_university.communication_file_categories.ordered
  end

end