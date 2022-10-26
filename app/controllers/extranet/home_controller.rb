class Extranet::HomeController < Extranet::ApplicationController
  def index
    @cohorts = about&.education_cohorts.ordered.limit(5)
    @experiences = about&.university_person_experiences.recent
  end
end
