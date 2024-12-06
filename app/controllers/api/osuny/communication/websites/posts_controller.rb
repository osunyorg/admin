class Api::Osuny::Communication::Websites::PostsController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :build_post, only: :create
  before_action :load_post, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @posts = website.posts.includes(:localizations)
  end

  def show
  end

  def create
    @post.assign_attributes post_params
    if @post.save
      render :show, status: :created
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update post_params
      render :show
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  protected

  def build_post
    @post = website.posts.build
  end

  def load_post
    @post = website.posts.find params[:id]
  end

  def load_migration_identifier
    @migration_identifier = post_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @post.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def post_params
    permitted_params = params.require(:post)
                        .permit(
                          :migration_identifier, :full_width,
                          localizations: [
                            :migration_identifier, :language, :title, :meta_description,
                            :featured_image, :featured_image_alt, :featured_image_credit,
                            :pinned, :published, :published_at, :slug, :subtitle, :summary, :_destroy
                          ]
                        ).merge(
                          university_id: current_university.id,
                          communication_website_id: website.id
                        )
    # permitted_params[:localizations_attributes].each do |localization_attributes|
    #   set_language_id_to_l10n_attributes(localization_attributes)
    #   post_l10n = @post.localizations.find_by(
    #     migration_identifier: localization_attributes[:migration_identifier],
    #     language_id: localization_attributes[:language_id]
    #   ) if @post.persisted?
    #   localization_attributes[:id] = post_l10n.id if post_l10n.present?
    #   set_featured_image_to_l10n_attributes(localization_attributes, l10n: post_l10n)
    # end
    permitted_params
  end

  def set_language_id_to_l10n_attributes(l10n_attributes)
    language_iso_code = l10n_attributes.delete(:language)
    l10n_attributes[:language_id] = Language.find_by(iso_code: language_iso_code)&.id
  end

  def set_featured_image_to_l10n_attributes(l10n_attributes, l10n: nil)
    featured_image_url = l10n_attributes.delete(:featured_image)
    # No image to upload
    return unless featured_image_url.present?
    # Image already uploaded
    return if l10n.present? && l10n.featured_image.attached? && l10n.featured_image.blob.metadata[:source_url] == featured_image_url
    l10n_attributes[:featured_image] = {
      io: URI.parse(featured_image_url).open,
      filename: File.basename(URI.parse(featured_image_url).path),
      metadata: { source_url: featured_image_url }
    }
  end
end
