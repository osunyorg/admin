class Extranet::PersonsController < Extranet::ApplicationController
  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: about&.university_person_alumni.for_language_id(current_university.default_language_id),
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
    @person = about.university_person_alumni.find(params[:id])
    breadcrumb
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), university_persons_path
    add_breadcrumb @person if @person
  end
end
