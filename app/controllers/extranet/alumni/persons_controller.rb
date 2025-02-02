class Extranet::Alumni::PersonsController < Extranet::Alumni::ApplicationController
  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: about&.university_person_alumni,
      about: about,
      language: current_language,
      categories: current_university.person_categories
    }
    @count = @facets.results.count
    @people =  @facets.results
                      .ordered(current_language)
                      .page(params[:page])
                      .per(72)
    breadcrumb
  end

  def show
    @person = about.university_person_alumni.find(params[:id])
    @l10n = @person.best_localization_for(current_language)
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person.model_name.human(count: 2), alumni_university_persons_path
  end
end
