class Admin::Communication::Extranets::PostsController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Post, through: :extranet

  def index
    breadcrumb
  end

  def show
    @preview = true
    breadcrumb
  end

  def preview
    # TODO faire une preview dans le bon contexte
    render layout: 'admin/layouts/preview'
  end

  def new
    @post.extranet = @extranet
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
    @post.extranet = @extranet
    @post.add_photo_import params[:photo_import]
    if @post.save
      redirect_to admin_communication_extranet_post_path(@post), notice: t('admin.successfully_created_html', model: @post.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post.add_photo_import params[:photo_import]
    if @post.update(post_params)
      redirect_to admin_communication_extranet_post_path(@post), notice: t('admin.successfully_updated_html', model: @post.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_communication_extranet_posts_url, notice: t('admin.successfully_destroyed_html', model: @post.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet::Post.model_name.human(count: 2), admin_communication_extranet_posts_path
    breadcrumb_for @post
  end

  def post_params
    params.require(:communication_extranet_post)
    .permit(
      :title, :summary, :text,
      :published, :published_at, :slug,
      :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
      :author_id
    )
    .merge(
      university_id: current_university.id
    )
  end

end