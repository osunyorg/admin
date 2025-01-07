class Admin::Communication::Medias::CategoriesController < Admin::Communication::Medias::ApplicationController
  load_and_authorize_resource class: Communication::Media::Category,
                              through: :current_university,
                              through_association: :communication_media_categories

  include Admin::ActAsCategories
  include Admin::Localizable

  def index
    @root_categories = categories.root.ordered(current_language)
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/communication/medias'
    breadcrumb
  end

  def show
    @medias =  @category.medias
                        .ordered(current_language)
                        .page(params[:page])
    breadcrumb
  end

  def new
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @l10n.add_photo_import params[:photo_import]
    if @category.save
      redirect_to admin_communication_media_category_path(@category),
                  notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      load_localization
      @l10n.add_photo_import params[:photo_import]
      redirect_to admin_communication_media_category_path(@category),
                  notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_media_categories_path,
                notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def categories_class
    Communication::Media::Category
  end

  def categories
    current_university.media_categories.ordered(current_language)
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Media::Category.model_name.human(count: 2),
                    admin_communication_media_categories_path
    breadcrumb_for @category
  end

  def category_params
    permitted_params_for(:communication_media_category)
  end
end
