class Admin::Communication::Websites::PostsController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Post,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  # Allow to override the default load_filters from Admin::Filterable
  before_action :load_filters, only: :index

  has_scope :for_search_term
  has_scope :for_author
  has_scope :for_category
  has_scope :for_pinned

  def index
    @posts = apply_scopes(@posts).tmp_original # TODO L10N : To remove
                                 .ordered(current_language)
                                 .page(params[:page])
    @feature_nav = 'navigation/admin/communication/website/posts'
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

  def new
    @categories = categories
    @post.author_id = current_user.person&.id
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @post.website = @website
    @post.add_photo_import params[:photo_import]
    if @post.save_and_sync
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_created_html', model: @post.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post.add_photo_import params[:photo_import]
    if @post.update_and_sync(post_params)
      redirect_to admin_communication_website_post_path(@post), notice: t('admin.successfully_updated_html', model: @post.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    redirect_to [:admin, @post.duplicate],
                notice: t('admin.successfully_duplicated_html', model: @post.to_s_in(current_language))
  end

  def destroy
    @post.destroy
    redirect_to admin_communication_website_posts_url, notice: t('admin.successfully_destroyed_html', model: @post.to_s_in(current_language))
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
      :author_id, category_ids: [],
      localizations_attributes: [
        :id, :title, :meta_description, :summary, :text,
        :published, :published_at, :slug, :pinned,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]
    )
    .merge(university_id: current_university.id)
  end

  def load_filters
    @filters = ::Filters::Admin::Communication::Website::Posts.new(
        current_user,
        @website,
        current_language
      ).list
  end

  def categories
    @website.post_categories
            .tmp_original # TODO L10N : To remove
            .ordered
  end
end
