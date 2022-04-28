class Admin::Communication::Website::PostsController < Admin::Communication::Website::ApplicationController
  skip_before_action :load_filters

  load_and_authorize_resource class: Communication::Website::Post, through: :website

  before_action :load_filters, only: :index

  has_scope :for_search_term

  def index
    @posts = apply_scopes(@posts).ordered.page params[:page]
    breadcrumb
  end

  def publish
    ids = params[:ids] || []
    target_posts = @website.posts.where(id: ids)
    if params[:published] == "true"
      target_posts.update(published: true)
    elsif params[:published] == "false"
      target_posts.update(published: false)
    end
    @website.sync_objects_with_git(target_posts) if target_posts.any?
    redirect_back fallback_location: admin_communication_website_posts_path,
                  notice: t('communication.website.posts.successful_batch_update')
  end

  def show
    breadcrumb
  end

  def new
    @post.website = @website
    @post.author_id = current_user.person&.id
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
            :university_id, :website_id, :title, :description, :description_short, :text,
            :published, :published_at, :featured_image, :featured_image_delete,
            :featured_image_infos, :featured_image_alt, :slug, :pinned,
            :author_id, :language_id, category_ids: []
          )
          .merge(university_id: current_university.id)
  end

  def load_filters
    @filters = ::Filters::Admin::Communication::Website::Posts.new(current_user, @website).list
  end
end
