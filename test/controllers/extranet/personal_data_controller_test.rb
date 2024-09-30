require "test_helper"

class Extranet::PersonalDataControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_edit
    get edit_personal_data_path(lang: french)
    assert_response(:success)
  end

  def test_update
    alumnus_person_l10n = alumnus_person.localization_for(french)
    assert(alumnus_person_l10n.biography.blank?)
    patch personal_data_path(lang: french), params: {
      university_person: {
        localizations_attributes: [
          { id: alumnus_person_l10n.id, biography: "<p>Je suis un ancien étudiant.</p>", language_id: french.id }
        ]
      }
    }
    assert_redirected_to(account_path(lang: french))
    assert(alumnus_person_l10n.reload.biography.to_s.include?("Je suis un ancien étudiant."))
  end
end
