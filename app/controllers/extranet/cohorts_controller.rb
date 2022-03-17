class Extranet::CohortsController < ApplicationController
  load_and_authorize_resource class: Education::Cohort,
                              through: :current_university,
                              through_association: :education_cohorts

  def index
    @cohorts = @cohorts.ordered.page(params[:page])
  end

  def show
  end
end
