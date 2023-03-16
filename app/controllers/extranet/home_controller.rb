class Extranet::HomeController < Extranet::ApplicationController
  def index
    @cohorts = about&.education_cohorts.ordered.limit(5)
    @experiences = about&.university_person_experiences.recent
    @posts = current_extranet.posts.published.ordered.limit(3) if current_extranet.feature_posts
  end
end
