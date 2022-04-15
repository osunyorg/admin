class Extranet::PersonsController < Extranet::ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  def index
    @people = current_extranet.about&.alumni || @people.alumni
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
