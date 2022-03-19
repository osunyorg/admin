class Api::LheoController < Api::ApplicationController
  def index
    @programs = current_university.education_programs
  end
end
