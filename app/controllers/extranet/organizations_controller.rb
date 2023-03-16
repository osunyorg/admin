class Extranet::OrganizationsController < Extranet::ApplicationController
  before_action :load_organization, only: [:show, :edit, :update]

  def search
    @term = params[:term].to_s
    @organizations = current_university.organizations
                                      .search_by_siren_or_name(@term)
                                      .ordered
  end

  def show
    breadcrumb
  end

  def new
    @organization = current_university.organizations.new
    @organization.name = params[:name] if params.has_key?(:name)
    breadcrumb
    add_breadcrumb t('create')
  end

  def create
    @organization = current_university.organizations.new(organization_params)
    if @organization.save
      redirect_to organization_path(@organization),
                  notice: t('admin.successfully_created_html', model: @organization.to_s)
    else
      breadcrumb
      add_breadcrumb t('create')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def update
    if @organization.update(organization_params)
      redirect_to organization_path(@organization),
                  notice: t('admin.successfully_updated_html', model: @organization.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2)
    add_breadcrumb @organization, organization_path(@organization) if @organization.persisted?
  end

  def load_organization
    # this is an "experience" organization so it can be not connected to the extranet
    @organization = current_university.organizations.find_by!(id: params[:id])
  end

  def organization_params
    params.require(:university_organization)
          .permit(
            :name, :long_name, :summary, :siren, :kind,
            :address, :address_name, :address_additional, :zipcode, :city, :country, :text,
            :url, :phone, :email, :linkedin, :twitter, :mastodon,
            :logo, :logo_delete, :logo_infos,
            :logo_on_dark_background, :logo_on_dark_background_delete, :logo_on_dark_background_infos,
          )
  end

end
