class Extranet::AcademicYearsController < ApplicationController
  load_and_authorize_resource class: Education::AcademicYear,
                              through: :current_university,
                              through_association: :academic_years

  def index
    @academic_years = @academic_years.ordered.page(params[:page])
  end

  def show
  end
end
