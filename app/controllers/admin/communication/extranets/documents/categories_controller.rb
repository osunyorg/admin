class Admin::Communication::Extranets::Documents::CategoriesController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Document::Category, through: :extranet, through_association: :document_categories

  include Admin::Localizable

  def index
    @categories = @categories.ordered(current_language)
    breadcrumb
    @feature_nav = 'navigation/admin/communication/extranet/library'
  end

  def show
    @documents = @category.documents
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
    if @category.save
      redirect_to admin_communication_extranet_document_category_path(@category), 
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_communication_extranet_document_category_path(@category), 
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_extranet_document_categories_url, 
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.human_attribute_name(:feature_documents), admin_communication_extranet_documents_path
    add_breadcrumb Communication::Extranet::Document::Category.model_name.human(count: 2), admin_communication_extranet_document_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_extranet_document_category)
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