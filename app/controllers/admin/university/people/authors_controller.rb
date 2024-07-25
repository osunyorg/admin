class Admin::University::People::AuthorsController < Admin::University::ApplicationController
  load_and_authorize_resource :author,
                              class: University::Person::Author,
                              through: :current_university,
                              through_association: :people

  include Admin::HasStaticAction
  include Admin::Localizable
end