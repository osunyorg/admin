class ProgramsController < ApplicationController
  load_and_authorize_resource

  add_breadcrumb 'Programmes', :programs_path

  def index
  end

  def show
    add_breadcrumb @program
  end
end
