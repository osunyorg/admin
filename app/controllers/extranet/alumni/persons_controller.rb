class Extranet::Alumni::PersonsController < Extranet::Alumni::ApplicationController
  def index
    @facets = University::Person::Alumnus::Facets.new params[:facets], {
      model: current_extranet.about.university_person_alumni,
      about: current_extranet.about,
      language: current_language,
      categories: current_university.person_categories
    }
    @people =  @facets.results
                      .ordered(current_language)
                      .page(params[:page])
                      .per(72)
    @count = @people.total_count
    breadcrumb
  end

  def show
    @person = current_extranet.about.university_person_alumni.find(params[:id])
    @l10n = @person.best_localization_for(current_language)
    @experiences =  current_extranet.about.alumni_experiences
                                          .where(person_id: @person.id)
                                          .ordered(current_language)
                                          .page(params[:page])
    @cohorts =  current_extranet.about.cohorts
                                      .joins(:people)
                                      .where(university_people: { id: @person.id })
                                      .ordered(current_language)
                                      .page(params[:page])
    breadcrumb
    add_breadcrumb @l10n
  end

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person.model_name.human(count: 2), alumni_university_persons_path
  end
end
