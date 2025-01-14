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
    set_current_person_as_author_of(@post)
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
    if @post.save
      @l10n.add_photo_import params[:photo_import]
      @post.sync_with_git
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
      respond_to do |format|
        format.html {
          redirect_to admin_communication_website_post_path(@post),
                      notice: t('admin.successfully_updated_html', model: @post.to_s_in(current_language))
        }
        format.json { 
          head :ok
        }
      end
    else
      load_invalid_localization
      @categories = categories
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    duplicate_post = @post.duplicate
    set_current_person_as_author_of(duplicate_post)
    redirect_to [:admin, duplicate_post],
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
    add_breadcrumb  @website.feature_posts_name(current_language),
                    admin_communication_website_posts_path
    breadcrumb_for @post
  end

  def post_params
    params.require(:communication_website_post)
    .permit(
      :full_width, author_ids: [], category_ids: [],
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

  def set_current_person_as_author_of(post)
    return unless current_user.person.present?
    current_user.person.update_column(:is_author, true)
    post.authors << current_user.person
  end
end
