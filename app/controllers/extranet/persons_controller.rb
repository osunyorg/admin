class Extranet::PersonsController < Extranet::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :about,
                              through_association: :university_person_alumni

  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: about&.university_person_alumni,
      about: about
    }
    @people = @facets.results
                     .ordered
                     .page(params[:page])
                     .per(60)
    @count = @people.total_count
    breadcrumb
  end

  def show
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), university_persons_path
    add_breadcrumb @person if @person
  end
end
