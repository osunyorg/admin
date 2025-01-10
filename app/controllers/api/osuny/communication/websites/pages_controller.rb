class Api::Osuny::Communication::Websites::PagesController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :build_page, only: :create
  before_action :load_page, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @pages = website.pages.includes(:localizations)
  end

  def show
  end

  def create
    if @page.save
      render :show, status: :created
    else
      render json: { errors: @page.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      render :show
    else
      render json: { errors: @page.errors }, status: :unprocessable_entity
    end
  end

  def upsert
    pages_params = params[:pages] || []
    every_page_has_migration_identifier = pages_params.all? { |page_params|
      page_params[:migration_identifier].present?
    }
    unless every_page_has_migration_identifier
      render_on_missing_migration_identifier
      return
    end

    permitted_pages_params = pages_params.map { |unpermitted_params|
      page_params_for_upsert(unpermitted_params)
    }
    @successfully_created_pages = []
    @successfully_updated_pages = []
    @invalid_pages_with_index = []
    permitted_pages_params.each_with_index do |permitted_page_params, index|
      page = website.pages.find_by(migration_identifier: permitted_page_params[:migration_identifier])
      if page.present?
        if page.update(permitted_page_params)
          @successfully_updated_pages << page
        else
          @invalid_pages_with_index << { page: page, index: index }
        end
      else
        page = website.pages.build(permitted_page_params)
        if page.save
          @successfully_created_pages << page
        else
          @invalid_pages_with_index << { page: page, index: index }
        end
      end
    end

    status = @invalid_pages_with_index.any? ? :unprocessable_entity : :ok
    render 'upsert', status: status
  end

  def destroy
    @page.destroy
    head :no_content
  end

  protected

  def build_page
    @page = website.pages.build
    @page.assign_attributes(page_params)
  end

  def load_page
    @page = website.pages.find(params[:id])
  end

  def load_migration_identifier
    @migration_identifier = page_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @page.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :title, :breadcrumb_title, :meta_description,
      :published, :published_at, :slug, :summary, :text,
      :header_text, :header_cta, :header_cta_label, :header_cta_url, :_destroy,
      featured_image: [:url, :alt, :credit, :_destroy],
      blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, data: {}]
    ]
  end

  def page_params
    @page_params ||= begin
      permitted_params = params.require(:page)
                          .permit(
                            :migration_identifier, :parent_id, :position, :bodyclass, :full_width, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params, @page) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def page_params_for_upsert(page_params)
    permitted_params = page_params
                          .permit(
                            :migration_identifier, :parent_id, :position, :bodyclass, :full_width, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
    page = website.pages.find_by(migration_identifier: permitted_params[:migration_identifier])
    permitted_params[:id] = page.id if page.present?
    set_l10n_attributes(permitted_params, page) if permitted_params[:localizations].present?
    permitted_params
  end
end
