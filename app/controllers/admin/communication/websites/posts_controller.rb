class Admin::Communication::Websites::PostsController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Post,
                              through: :website

  include Admin::HasStaticAction
  include Admin::Localizable

  def index
    @posts = @posts.filter_by(params[:filters], current_language)
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
      l10n = post.localization_for(current_language)
      next unless l10n.present?
      l10n.publish!
      post.save_and_sync
    end
    redirect_back fallback_location: admin_communication_website_posts_path,
                  notice: t('communication.website.posts.successful_batch_update')
  end

  def publish
    @l10n.publish!
    @post.sync_with_git
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
    if current_user.person.present?
      current_user.person.update_column(:is_author, true)
      @post.author = current_user.person
    end
    @categories = categories
    breadcrumb
  end

  def edit
    @categories = categories
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @post.website = @website
    @l10n.add_photo_import params[:photo_import]
    if @post.save_and_sync
      redirect_to admin_communication_website_post_path(@post),
                  notice: t('admin.successfully_created_html', model: @post.to_s_in(current_language))
    else
      @categories = categories
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      load_localization
      @l10n.add_photo_import params[:photo_import]
      @post.sync_with_git
      redirect_to admin_communication_website_post_path(@post),
                  notice: t('admin.successfully_updated_html', model: @post.to_s_in(current_language))
    else
      load_invalid_localization
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
    redirect_to admin_communication_website_posts_url,
                notice: t('admin.successfully_destroyed_html', model: @post.to_s_in(current_language))
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
      author_ids: [], category_ids: [],
      localizations_attributes: [
        :id, :title, :subtitle, :meta_description, :summary, :text,
        :published, :published_at, :slug, :pinned,
        :featured_image, :featured_image_delete, :featured_image_infos, :featured_image_alt, :featured_image_credit,
        :shared_image, :shared_image_delete, :shared_image_infos,
        :language_id
      ]
    )
    .merge(university_id: current_university.id)
  end

  def categories
    @website.post_categories
            .ordered
  end
end
