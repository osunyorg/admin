class Extranet::PersonsController < Extranet::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: about&.alumni,
      about: current_extranet.about
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
