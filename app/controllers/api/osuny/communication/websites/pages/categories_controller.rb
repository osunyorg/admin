class Api::Osuny::Communication::Websites::Pages::CategoriesController < Api::Osuny::Communication::Websites::ApplicationController
  before_action :build_category, only: :create
  before_action :load_category, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @categories = website.page_categories.includes(:localizations)
  end

  def show
  end

  def create
    if @category.save
      render :show, status: :created
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render :show
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  end

  def upsert
    categories_params = params[:categories] || []
    every_category_has_migration_identifier = categories_params.all? { |category_params|
      category_params[:migration_identifier].present?
    }
    unless every_category_has_migration_identifier
      render_on_missing_migration_identifier
      return
    end

    permitted_categories_params = categories_params.map { |unpermitted_params|
      category_params_for_upsert(unpermitted_params)
    }
    @successfully_created_categories = []
    @successfully_updated_categories = []
    @invalid_categories_with_index = []
    permitted_categories_params.each_with_index do |permitted_category_params, index|
      category = website.page_categories.find_by(migration_identifier: permitted_category_params[:migration_identifier])
      if category.present?
        if category.update(permitted_category_params)
          @successfully_updated_categories << category
        else
          @invalid_categories_with_index << { category: category, index: index }
        end
      else
        category = website.page_categories.build(permitted_category_params)
        if category.save
          @successfully_created_categories << category
        else
          @invalid_categories_with_index << { category: category, index: index }
        end
      end
    end

    status = @invalid_categories_with_index.any? ? :unprocessable_entity : :ok
    render 'upsert', status: status
  end

  def destroy
    @category.destroy
    head :no_content
  end

  protected

  def build_category
    @category = website.page_categories.build
    @category.assign_attributes(category_params)
  end

  def load_category
    @category = website.page_categories.find(params[:id])
  end

  def load_migration_identifier
    @migration_identifier = category_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @category.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :name, :meta_description,
      :path, :slug, :summary, :_destroy,
      featured_image: [:url, :alt, :credit, :_destroy],
      blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, data: {}]
    ]
  end

  def category_params
    @category_params ||= begin
      permitted_params = params.require(:category)
                          .permit(
                            :migration_identifier, :parent_id, :position, :is_taxonomy, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
      set_l10n_attributes(permitted_params, @category) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def category_params_for_upsert(category_params)
    permitted_params = category_params
                          .permit(
                            :migration_identifier, :parent_id, :position, :is_taxonomy, localizations: {}
                          ).merge(
                            university_id: current_university.id,
                            communication_website_id: website.id
                          )
    category = website.page_categories.find_by(migration_identifier: permitted_params[:migration_identifier])
    permitted_params[:id] = category.id if category.present?
    set_l10n_attributes(permitted_params, category) if permitted_params[:localizations].present?
    permitted_params
  end
end
