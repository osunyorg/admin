class Extranet::HomeController < Extranet::ApplicationController
  def index
    return redirect_to admin_root_path unless current_extranet
    @cohorts = current_extranet.about&.cohorts || current_university.education_cohorts
    @cohorts = @cohorts.ordered.limit(5)
  end
end
