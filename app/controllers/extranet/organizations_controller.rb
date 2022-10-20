class Extranet::OrganizationsController < Extranet::ApplicationController
  def index
    @facets = University::Organization::Facets.new params[:facets], {
      model: about&.university_person_alumni_organizations,
      about: about
    }
    @organizations = @facets.results
                      .ordered
                      .page(params[:page])
                      .per(60)
    @count = @organizations.total_count
    breadcrumb
  end

  def search
    @term = params[:term]
    @organizations = current_extranet.organizations
                                      .for_search_term(@term)
                                      .ordered
  end

  def show
    @organization = about.university_person_alumni_organizations.find(params[:id])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Organization.model_name.human(count: 2), university_organizations_path
    add_breadcrumb @organization if @organization
  end
end
