class Extranet::HomeController < Extranet::ApplicationController
  def index
    load_posts_variables if current_extranet.feature_posts?
    load_alumni_variables if current_extranet.feature_alumni?
  end

  def redirect_to_default_language
    default_language = current_user.language
    default_language = current_extranet.default_language unless current_extranet.active_languages.include?(default_language)
    redirect_to extranet_root_path(lang: default_language)
  end

  protected

  def load_posts_variables
    @posts =  current_extranet.posts
                              .published(current_language)
                              .ordered(current_language)
                              .limit(3)
  end

  def load_alumni_variables
    @cohorts =  current_extranet.about.education_cohorts
                                      .ordered(current_language)
                                      .limit(5)
    @experiences =  current_extranet.about.university_person_experiences
                                          .latest
  end
end
