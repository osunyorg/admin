class Extranet::Alumni::OrganizationsController < Extranet::Alumni::ApplicationController
  def index
    @facets = University::Organization::Facets.new params[:facets], {
      model: current_extranet.about.university_person_alumni_organizations,
      about: current_extranet.about,
      language: current_language,
      categories: current_university.organization_categories
    }
    @organizations = @facets.results
                            .ordered(current_language)
                            .page(params[:page])
    @count = @organizations.total_count
    breadcrumb
  end

  def show
    @organization = current_extranet.about.university_person_alumni_organizations.find(params[:id])
    @l10n = @organization.best_localization_for(current_language)
    @experiences =  current_extranet.about.alumni_experiences
                                          .where(organization_id: @organization.id)
                                          .ordered(current_language)
                                          .page(params[:page])
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Organization.model_name.human(count: 2), alumni_university_organizations_path
  end
end
