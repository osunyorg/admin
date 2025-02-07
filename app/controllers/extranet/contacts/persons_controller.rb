class Extranet::Contacts::PersonsController < Extranet::Contacts::ApplicationController
  def index
    @people = current_extranet.connected_people
                              .ordered(current_language)
                              .page(params[:page])
    @count = @people.total_count
    breadcrumb
  end

  def show
    @person = current_extranet.connected_people.find(params[:id])
    @l10n = @person.best_localization_for(@person)
    @current_experiences = @person.experiences
                                  .joins(:organization)
                                  .where(university_organizations: { id: current_extranet.connected_organizations.pluck(:id) })
                                  .current
                                  .ordered(current_language)
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person.model_name.human(count: 2), contacts_persons_path
  end
end
