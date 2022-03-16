class Extranet::OrganizationsController < ApplicationController
  load_and_authorize_resource class: University::Organization,
                              through: :current_university,
                              through_association: :organizations

  def index
    @organizations = @organizations.ordered.page(params[:page])
  end

  def show
  end
end
