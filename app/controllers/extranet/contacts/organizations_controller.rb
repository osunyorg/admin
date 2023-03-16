class Extranet::Contacts::OrganizationsController < Extranet::Contacts::ApplicationController
  def index
    @organizations = current_extranet.connected_organizations
                                     .ordered
                                     .page(params[:page])
                                     .per(60)
    @count = @organizations.total_count
    breadcrumb
  end

  def show
    @organization = current_extranet.connected_organizations.find(params[:id])
    @current_experiences = @organization.experiences.includes(:person).current.ordered
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Organization.model_name.human(count: 2), contacts_university_organizations_path
    add_breadcrumb @organization if @organization
  end
end
