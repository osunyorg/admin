class Admin::Communication::Extranets::PostsController < Admin::Communication::Extranets::ApplicationController
  load_and_authorize_resource class: Communication::Extranet::Post, through: :extranet

  include Admin::Localizable

  def index
    @posts =  @posts.ordered(current_language)
                    .page(params[:page])
    breadcrumb
    @feature_nav = 'navigation/admin/communication/extranet/posts'
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
    if current_user.person.present?
      current_user.person&.update_column(:is_author, true)
      @post.authors << current_user.person
    end
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @l10n.add_photo_import params[:photo_import]
    if @post.save
      redirect_to admin_communication_extranet_post_path(@post),
                  notice: t('admin.successfully_created_html', model: @post.to_s_in(current_language))
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      load_localization
      @l10n.add_photo_import params[:photo_import]
      redirect_to admin_communication_extranet_post_path(@post),
                  notice: t('admin.successfully_updated_html', model: @post.to_s_in(current_language))
    else
      load_invalid_localization
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_communication_extranet_posts_url,
                notice: t('admin.successfully_destroyed_html', model: @post.to_s_in(current_language))
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
      :author_id, :category_id,
      localizations_attributes: [
        :id, :language_id,
        :title, :summary, :text,
        :published, :published_at, :pinned, :slug,
        :featured_image, :featured_image_delete, :featured_image_infos,
        :featured_image_alt, :featured_image_credit
      ]
    )
    .merge(
      university_id: current_university.id
    )
  end

end