class Admin::Communication::Extranets::DocumentsController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Document, through: :extranet

  include Admin::Localizable

  def index
    @documents =  @documents.ordered(current_language)
                            .page(params[:page])
    breadcrumb
    @feature_nav = 'navigation/admin/communication/extranet/library'
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
    @document.extranet = @extranet
    if @document.save
      redirect_to admin_communication_extranet_document_path(@document), 
                  notice: t('admin.successfully_created_html', model: @document.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @document.update(document_params)
      redirect_to admin_communication_extranet_document_path(@document), 
                  notice: t('admin.successfully_updated_html', model: @document.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @document.destroy
    redirect_to admin_communication_extranet_documents_url, 
                notice: t('admin.successfully_destroyed_html', model: @document.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_documents), admin_communication_extranet_documents_path
    breadcrumb_for @document
  end

  def document_params
    params.require(:communication_extranet_document)
    .permit(
      :category_id, :kind_id,
      localizations_attributes: [
        :id, :language_id,
        :name, :published, :published_at, :slug,
        :file, :file_delete, :file_infos
      ]
    )
    .merge(
      university_id: current_university.id
    )
  end
end