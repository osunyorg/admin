class Admin::Communication::Extranets::Documents::KindsController < Admin::Communication::Extranets::Documents::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Document::Kind, through: :extranet, through_association: :document_kinds

  def index
    @kinds = @kinds.ordered
    breadcrumb
  end

  def show
    @documents = @kind.documents.ordered.page params[:page]
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
      redirect_to admin_communication_extranet_document_kind_path(@kind), notice: t('admin.successfully_created_html', model: @kind.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @kind.update(kind_params)
      redirect_to admin_communication_extranet_document_kind_path(@kind), notice: t('admin.successfully_updated_html', model: @kind.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @kind.destroy
    redirect_to admin_communication_extranet_document_kinds_url, notice: t('admin.successfully_destroyed_html', model: @kind.to_s)
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
      :name,
      :slug,
    )
    .merge(
      university_id: current_university.id
    )
  end

end