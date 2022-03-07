class University::OrganizationsController < ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  def index
  end

  def show
  end
end
