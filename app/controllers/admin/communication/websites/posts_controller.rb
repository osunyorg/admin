class Admin::Communication::Websites::PostsController < Admin::Communication::Websites::ApplicationController
  skip_before_action :load_filters

  load_and_authorize_resource class: Communication::Website::Post, through: :website

  include Admin::Translatable

  before_action :load_filters, only: :index
  before_action :load_categories, only: [:new, :edit]

  has_scope :for_search_term
  has_scope :for_author
  has_scope :for_category
  has_scope :for_pinned

  def index
    @posts = apply_scopes(@posts).for_language(current_website_language).ordered.page params[:page]
    @authors =  @website.authors.for_language(current_website_language)
                                .accessible_by(current_ability)
                                .ordered
                                .page(params[:authors_page])
    @root_categories = @website.categories.for_language(current_website_language).root.ordered
    breadcrumb
  end

  def publish_batch
    ids = params[:ids] || []
    target_posts = @website.posts.where(id: ids)
    is_published = params[:published] == "true"
    target_posts.each do |post|
      post.published = is_published
      post.save_and_sync
    end
    redirect_back fallback_location: admin_communication_website_posts_path,
                  notice: t('communication.website.posts.successful_batch_update')
  end

  def publish
    @post.published = true
    @post.save_and_sync
    redirect_back fallback_location: admin_communication_website_post_path(@post),
                  notice: t('admin.communication.website.publish.notice')
  end

  def show
    @preview = true
    breadcrumb
  end

  def preview
    render layout: 'admin/layouts/preview'
  end

  def static
    @about = @post
    render layout: false
  end

  def new
    @post.website = @website
    if current_user.person.present?
      @post.author_id = current_user.person.find_or_translate!(current_website_language).id
    end
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @post.website = @website
    @post.add_photo_import params[:photo_import]
    if @post.save_and_sync
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_created_html', model: @post.to_s)
    else
      load_categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post.add_photo_import params[:photo_import]
    if @post.update_and_sync(post_params)
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_updated_html', model: @post.to_s)
    else
      load_categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @post.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @post.to_s)
  end

  def destroy
    @post.destroy
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
      :title, :meta_description, :summary, :text,
      :published, :published_at, :slug, :pinned,
      :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
      :author_id, category_ids: []
    )
    .merge(
      university_id: current_university.id,
      language_id: current_website_language.id
    )
  end

  def load_filters
    @filters = ::Filters::Admin::Communication::Website::Posts.new(current_user, @website).list
  end
end
