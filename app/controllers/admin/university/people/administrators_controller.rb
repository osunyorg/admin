class Admin::University::People::AdministratorsController < Admin::University::ApplicationController
  load_and_authorize_resource :administrator,
                              class: University::Person::Administrator,
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable
end