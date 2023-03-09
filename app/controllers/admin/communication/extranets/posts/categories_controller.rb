class Admin::Communication::Extranets::Posts::CategoriesController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Post::Category, through: :extranet

  def index
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    if current_user.person.present?
      @post.author = current_user.person
    end
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    if @category.save
      redirect_to admin_communication_extranet_post_category_path(@category), notice: t('admin.successfully_created_html', model: @category.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.add_photo_import params[:photo_import]
    if @category.update(category_params)
      redirect_to admin_communication_extranet_post_category_path(@category), notice: t('admin.successfully_updated_html', model: @category.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_communication_extranet_post_categories_url, notice: t('admin.successfully_destroyed_html', model: @category.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet::Post::Category.model_name.human(count: 2), admin_communication_extranet_post_categories_path
    breadcrumb_for @category
  end

  def category_params
    params.require(:communication_extranet_post_category)
    .permit(
      :name,
    )
    .merge(
      university_id: current_university.id
    )
  end

end