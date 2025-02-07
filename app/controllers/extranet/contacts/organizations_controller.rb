class Extranet::Contacts::OrganizationsController < Extranet::Contacts::ApplicationController
  def index
    @organizations =  current_extranet.connected_organizations
                                      .ordered(current_language)
                                      .page(params[:page])
    @count = @organizations.total_count
    breadcrumb
  end

  def show
    @organization = current_extranet.connected_organizations.find(params[:id])
    @l10n = @organization.best_localization_for(current_language)
    @people = current_extranet.connected_people
                                .joins(:experiences)
                                .merge(University::Person::Experience.current.where(organization_id: @organization.id))
                                .ordered(current_language)
                                .page(params[:page])
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Organization.model_name.human(count: 2), contacts_organizations_path
  end
end
