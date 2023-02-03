class Admin::University::People::TranslationsController < Admin::University::ApplicationController
  load_and_authorize_resource :person,
                              class: University::Person,
                              id_param: :person_id,
                              through: :current_university,
                              through_association: :people,
                              parent: false

  def show
    language = Language.find_by!(iso_code: params[:lang])
    # Early return if language is correct
    return [:admin, @person] if @person.language_id == language.id
    # Look up for translation from person
    translation = @person.translation_for(language)
    # If not found, translate the current person (with blocks and all) for given language
    translation ||= @person.translate!(language)
    # Redirect to the translation
    redirect_to [:admin, translation.becomes(translation.class.base_class)]
  end
end
