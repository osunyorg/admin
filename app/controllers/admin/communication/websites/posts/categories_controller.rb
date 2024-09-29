class Admin::Communication::Websites::Posts::CategoriesController < Admin::Communication::Websites::Posts::ApplicationController
  load_and_authorize_resource class: Communication::Website::Post::Category,
                              through: :website,
                              through_association: :post_categories

  include Admin::ActAsCategories
  include Admin::Localizable
  include Admin::HasStaticAction

  def index
    @root_categories = categories.root
                                 .tmp_original # TODO L10N : To remove
                                 .ordered
    @categories_class = categories_class
    @feature_nav = 'navigation/admin/communication/website/posts'
    breadcrumb
  end

  def show
    @posts = @category.posts.ordered(current_language).page(params[:page])
    breadcrumb
  end

  def new
    @category.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @category.website = @website
    @l10n.add_photo_import params[:photo_import]
    if @category.save_and_sync
      redirect_to admin_communication_website_post_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @l10n.add_photo_import params[:photo_import]
    if @category.update_and_sync(category_params)
      redirect_to admin_communication_website_post_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s_in(current_language))
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_website_post_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s_in(current_language))
  end

  protected

  def get_root_categories
    @root_categories = categories.root
  end

  def categories_class
    Communication::Website::Post::Category
  end

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Post::Category.model_name.human(count: 2),
                    admin_communication_website_post_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_website_post_category)
          .permit(
            :parent_id,
            localizations_attributes: [
              :id, :name, :meta_description, :summary, :slug,
              :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
              :language_id
            ]
          )
          .merge(
            university_id: current_university.id,
            language_id: current_language.id
          )
  end
end
