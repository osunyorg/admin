class Admin::University::People::ResearchersController < Admin::University::ApplicationController
  load_and_authorize_resource :researcher,
                              class: University::Person::Researcher,
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable
end