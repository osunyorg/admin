class Admin::Communication::Website::PostsController < Admin::Communication::Website::ApplicationController
  load_and_authorize_resource class: Communication::Website::Post, through: :website

  def index
    @posts = @posts.ordered.page params[:page]
    breadcrumb
  end

  def show
    breadcrumb
  end

  def new
    @post.website = @website
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @post.website = @website
    if @post.save_and_sync
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_created_html', model: @post.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update_and_sync(post_params)
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_updated_html', model: @post.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy_and_sync
    redirect_to admin_communication_website_posts_url, notice: t('admin.successfully_destroyed_html', model: @post.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb  Communication::Website::Post.model_name.human(count: 2),
                    admin_communication_website_posts_path
    breadcrumb_for @post
  end

  def post_params
    params.require(:communication_website_post)
          .permit(
            :university_id, :website_id, :title, :description, :text, :text_new, 
            :published, :published_at, :featured_image, :featured_image_delete,
            :featured_image_infos, :featured_image_alt, :slug, :pinned,
            :author_id, category_ids: []
          )
          .merge(university_id: current_university.id)
  end
end
