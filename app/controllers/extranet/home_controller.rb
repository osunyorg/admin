class Extranet::HomeController < Extranet::ApplicationController
  def index
    return redirect_to admin_root_path unless current_extranet
    @about = current_extranet.about || current_university
    @cohorts = @about&.cohorts.ordered.limit(5)
    @experiences = @about&.experiences.ordered.limit(10)
  end
end
