class Admin::University::People::TeachersController < Admin::University::ApplicationController
  load_and_authorize_resource :teacher,
                              class: University::Person::Researcher,
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable
end