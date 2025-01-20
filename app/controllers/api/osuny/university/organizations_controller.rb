class Api::Osuny::University::OrganizationsController < Api::Osuny::ApplicationController
  before_action :build_organization, only: :create
  before_action :load_organization, only: [:show, :update, :destroy]

  before_action :load_migration_identifier, only: [:create, :update]
  before_action :ensure_same_migration_identifier, only: :update

  def index
    @organizations = current_university.organizations.includes(:localizations)
  end

  def show
  end

  def create
    if @organization.save
      render :show, status: :created
    else
      render json: { errors: @organization.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      render :show
    else
      render json: { errors: @organization.errors }, status: :unprocessable_entity
    end
  end

  def upsert
    organizations_params = params[:organizations] || []
    every_organization_has_migration_identifier = organizations_params.all? { |organization_params|
      organization_params[:migration_identifier].present?
    }
    unless every_organization_has_migration_identifier
      render_on_missing_migration_identifier
      return
    end

    permitted_organizations_params = organizations_params.map { |unpermitted_params|
      organization_params_for_upsert(unpermitted_params)
    }
    @successfully_created_organizations = []
    @successfully_updated_organizations = []
    @invalid_organizations_with_index = []
    permitted_organizations_params.each_with_index do |permitted_organization_params, index|
      organization = current_university.organizations.find_by(migration_identifier: permitted_organization_params[:migration_identifier])
      if organization.present?
        if organization.update(permitted_organization_params)
          @successfully_updated_organizations << organization
        else
          @invalid_organizations_with_index << { organization: organization, index: index }
        end
      else
        organization = current_university.organizations.build(permitted_organization_params)
        if organization.save
          @successfully_created_organizations << organization
        else
          @invalid_organizations_with_index << { organization: organization, index: index }
        end
      end
    end

    status = @invalid_organizations_with_index.any? ? :unprocessable_entity : :ok
    render 'upsert', status: status
  end

  def destroy
    @organization.destroy
    head :no_content
  end

  protected

  def build_organization
    @organization = current_university.organizations.build
    @organization.assign_attributes(organization_params)
  end

  def load_organization
    @organization = current_university.organizations.find(params[:id])
  end

  def load_migration_identifier
    @migration_identifier = organization_params[:migration_identifier]
    render_on_missing_migration_identifier unless @migration_identifier.present?
  end

  def ensure_same_migration_identifier
    if @organization.migration_identifier != @migration_identifier
      render json: { error: 'Migration identifier does not match' }, status: :unprocessable_entity
    end
  end

  def l10n_permitted_keys
    [
      :migration_identifier, :language, :name, :long_name, :meta_description,
      :address_name, :address_additional, :linkedin, :mastodon, :twitter, :url,
      :slug, :summary, :text, :_destroy,
      featured_image: [:url, :alt, :credit, :_destroy],
      blocks: [:migration_identifier, :template_kind, :title, :position, :published, :html_class, data: {}]
    ]
  end

  def organization_params
    @organization_params ||= begin
      permitted_params = params.require(:organization)
                          .permit(
                            :migration_identifier, :kind, :active, :email, :phone,
                            :address, :zipcode, :city, :country, :nic, :siren,
                            category_ids: [], localizations: {}
                          ).merge(university_id: current_university.id)
      set_l10n_attributes(permitted_params, @organization) if permitted_params[:localizations].present?
      permitted_params
    end
  end

  def organization_params_for_upsert(organization_params)
    permitted_params = organization_params
                          .permit(
                            :migration_identifier, :kind, :active, :email, :phone,
                            :address, :zipcode, :city, :country, :nic, :siren,
                            category_ids: [], localizations: {}
                          ).merge(university_id: current_university.id)
    organization = current_university.organizations.find_by(migration_identifier: permitted_params[:migration_identifier])
    permitted_params[:id] = organization.id if organization.present?
    set_l10n_attributes(permitted_params, organization) if permitted_params[:localizations].present?
    permitted_params
  end
end
