class Extranet::PersonsController < ApplicationController
  load_and_authorize_resource class: University::Person::Alumnus,
                              through: :current_university,
                              through_association: :people

  def index
  end

  def show
  end
end
