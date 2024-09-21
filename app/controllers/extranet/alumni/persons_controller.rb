class Extranet::Alumni::PersonsController < Extranet::Alumni::ApplicationController
  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: about&.university_person_alumni.tmp_original
      about: about,
      language: current_language
    }
    @people =  @facets.results
                      .ordered(current_language)
                      .page(params[:page])
                      .per(72)
    @count = @people.total_count
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
