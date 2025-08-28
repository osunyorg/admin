class Extranet::OrganizationsController < Extranet::ApplicationController
  def search
    @term = params[:term].to_s
    @organizations = current_university.organizations
                                       .search_by_siren_or_name(@term, current_language)
                                       .ordered(current_language)
  end

  def new
    @organization = current_university.organizations.new
    @l10n = @organization.localizations.build(language: current_language)
    @l10n.name = params[:name] if params.has_key?(:name)
    breadcrumb
    add_breadcrumb t('create')
  end

  def create
    @organization = current_university.organizations.new(organization_params)
    if @organization.save
      redirect_to new_account_experience_path(organization_id: @organization.id),
                  notice: t('admin.successfully_created_html', model: @organization.to_s_in(current_language))
    else
      @l10n = @organization.localizations.first
      breadcrumb
      add_breadcrumb t('create')
      render :new, status: :unprocessable_content
    end
  end

  private

  def breadcrumb
    super
    add_breadcrumb  University::Organization.model_name.human(count: 2)
  end

  def load_organization
    # this is an "experience" organization so it can be not connected to the extranet
    @organization = current_university.organizations.find_by!(id: params[:id])
  end

  def organization_params
    params.require(:university_organization)
          .permit(
            :siren, :kind, :address, :zipcode, :city, :country, :phone, :email, category_ids: [],
            localizations_attributes: [
              :id, :name, :long_name, :slug, :meta_description, :summary, :text,
              :address_name, :address_additional,
              :url, :linkedin, :twitter, :mastodon,
              :logo, :logo_delete, :logo_infos,
              :logo_on_dark_background, :logo_on_dark_background_delete, :logo_on_dark_background_infos,
              :shared_image, :shared_image_delete,
              :language_id
            ]
          )
  end

end
