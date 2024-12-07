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
    @post_params ||= begin
      permitted_params = params.require(:post)
                          .permit(
                            :migration_identifier, :full_width, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def set_l10n_attributes(base_params)
      l10ns_attributes = base_params.delete(:localizations)
      base_params[:localizations_attributes] = []
      l10ns_attributes.each do |language_iso_code, l10n_params|
        l10n_permitted_params = l10n_params.permit(
          :migration_identifier, :language, :title, :meta_description,
          :pinned, :published, :published_at, :slug, :subtitle, :summary, :_destroy,
          featured_image: [:url, :alt, :credit, :_destroy]
        )

        l10n_permitted_params[:language_id] = Language.find_by(iso_code: language_iso_code)&.id

        existing_post_l10n = @post.localizations.find_by(
          migration_identifier: l10n_permitted_params[:migration_identifier],
          language_id: l10n_permitted_params[:language_id]
        ) if @post.persisted?
        l10n_permitted_params[:id] = existing_post_l10n.id if existing_post_l10n.present?

        set_featured_image_to_l10n_params(l10n_permitted_params, l10n: existing_post_l10n)

        base_params[:localizations_attributes] << l10n_permitted_params
      end
  end

  def set_featured_image_to_l10n_params(l10n_params, l10n: nil)
    featured_image_data = l10n_params.delete(:featured_image)
    return unless featured_image_data.present?
    l10n_params[:featured_image_alt] = featured_image_data[:alt] if featured_image_data.has_key?(:alt)
    l10n_params[:featured_image_credit] = featured_image_data[:credit] if featured_image_data.has_key?(:credit)
    l10n_params[:featured_image_delete] = '1' if featured_image_data[:_destroy]
    featured_image_url = featured_image_data[:url]
    # No image to upload
    return unless featured_image_url.present?
    # Image already uploaded
    return if l10n.present? && l10n.featured_image.attached? && l10n.featured_image.blob.metadata[:source_url] == featured_image_url
    l10n_params[:featured_image] = {
      io: URI.parse(featured_image_url).open,
      filename: File.basename(URI.parse(featured_image_url).path),
      metadata: { source_url: featured_image_url }
    }
  end
end
