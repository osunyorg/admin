class Admin::Communication::Extranets::DocumentsController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Document, through: :extranet

  def index
    @documents = @documents.ordered.page params[:page]
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @document.save
      redirect_to admin_communication_extranet_document_path(@document), notice: t('admin.successfully_created_html', model: @document.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @document.update(document_params)
      redirect_to admin_communication_extranet_document_path(@document), notice: t('admin.successfully_updated_html', model: @document.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to admin_communication_extranet_documents_url, notice: t('admin.successfully_destroyed_html', model: @document.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_library), admin_communication_extranet_library_path
    breadcrumb_for @document
  end

  def document_params
    params.require(:communication_extranet_document)
    .permit(
      :name, :published, :published_at, :slug,
      :file, :file_delete
    )
    .merge(
      university_id: current_university.id
    )
  end
end