require "test_helper"

class Extranet::Account::ExperiencesControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_new
    get new_account_experience_path(lang: french)
    assert_response(:success)
  end

  def test_create
    assert_difference("alumnus.experiences.count") do
      post account_experiences_path(lang: french), params: {
        university_person_experience: {
          description: "Stage",
          from_year: 2022,
          to_year: 2022,
          organization_id: university_organizations(:default_organization).id,
          localizations_attributes: [
            { description: "Stage", language_id: french.id }
          ]
        }
      }
      assert_redirected_to(account_path(lang: french))
    end
  end

  def test_create_invalid
    assert_no_difference("alumnus.experiences.count") do
      post account_experiences_path(lang: french), params: {
        university_person_experience: {
          from_year: 2022,
          to_year: 2022,
          localizations_attributes: [
            { description: "Stage", language_id: french.id }
          ]
        }
      }
      assert_response(:unprocessable_entity)
    end
  end

  def test_edit
    get edit_account_experience_path(university_person_experiences(:default_experience), lang: french)
    assert_response(:success)
  end

  def test_update
    experience = university_person_experiences(:default_experience)
    experience_l10n = experience.localization_for(french)

    assert(experience_l10n.description.blank?)
    patch account_experience_path(experience, lang: french), params: {
      university_person_experience: {
        localizations_attributes: [
          { id: experience_l10n.id, description: "Alternance", language_id: french.id }
        ]
      }
    }
    assert_redirected_to(account_path(lang: french))
    assert_equal("Alternance", experience_l10n.reload.description)
  end

  def test_update_invalid
    experience = university_person_experiences(:default_experience)

    patch account_experience_path(experience, lang: french), params: {
      university_person_experience: {
        organization_id: ""
      }
    }
    assert_response(:unprocessable_entity)
  end

end
