class Extranet::HomeController < Extranet::ApplicationController
  def index
    @cohorts = about&.education_cohorts.ordered.limit(5)
    @experiences = about&.university_person_experiences.latest
    @posts =  current_extranet.posts
                              .published(current_language)
                              .ordered(current_language)
                              .limit(3) if current_extranet.feature_posts
  end

  def redirect_to_default_language
    # TODO L10N vérifier par rapport aux langues de l'extranet
    redirect_to root_path(lang: current_university.default_language)
  end
end
