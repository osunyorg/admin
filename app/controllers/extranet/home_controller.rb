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
    default_language = current_user.language
    default_language = current_extranet.default_language unless current_extranet.active_languages.include?(default_language)
    redirect_to extranet_root_path(lang: default_language)
  end
end
