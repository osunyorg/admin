class Admin::University::People::AdministratorsController < Admin::University::ApplicationController
  load_and_authorize_resource :person,
                              class: University::Person,
                              through: :current_university,
                              through_association: :people,
                              parent: false

  include Admin::HasStaticAction
  include Admin::Localizable

  protected

  # On every other action, we need to load the localization
  def load_localization
    @l10n = super.administrator
  end

  def resource_name
    "person"
  end
end