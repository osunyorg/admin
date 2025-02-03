class Admin::Communication::Extranets::Documents::KindsController < Admin::Communication::Extranets::Documents::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Document::Kind,
                              through: :extranet,
                              through_association: :document_kinds

  include Admin::Localizable

  def index
    @kinds = @kinds.ordered(current_language)
    breadcrumb
    @feature_nav = 'navigation/admin/communication/extranet/library'
  end

  def show
    @documents = @kind.documents
                      .ordered(current_language)
                      .page(params[:page])
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
    if @kind.save
      redirect_to admin_communication_extranet_document_kind_path(@kind),
                  notice: t('admin.successfully_created_html', model: @kind.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @kind.update(kind_params)
      redirect_to admin_communication_extranet_document_kind_path(@kind),
                  notice: t('admin.successfully_updated_html', model: @kind.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @kind.destroy
    redirect_to admin_communication_extranet_document_kinds_url,
                notice: t('admin.successfully_destroyed_html', model: @kind.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet::Document::Kind.model_name.human(count: 2), admin_communication_extranet_document_kinds_path
    breadcrumb_for @kind
  end

  def kind_params
    params.require(:communication_extranet_document_kind)
    .permit(
      localizations_attributes: [
        :id, :language_id,
        :name, :slug
      ]
    )
    .merge(
      university_id: current_university.id
    )
  end

end