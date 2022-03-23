class Extranet::HomeController < Extranet::ApplicationController
  def index
    redirect_to admin_root_path unless current_extranet
    @cohorts = current_university.education_cohorts.ordered.limit(2)
  end
end
