require "test_helper"

class Extranet::ExperiencesControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_new
    get new_experience_path
    assert_response(:success)
  end

  def test_create
    assert_difference("alumnus.experiences.count") do
      post experiences_path, params: {
        university_person_experience: {
          description: "Stage",
          from_year: 2022,
          to_year: 2022,
          organization_id: university_organizations(:default_organization).id
        }
      }
      assert_redirected_to(account_path)
    end
  end

  def test_edit
    get edit_experience_path(university_person_experiences(:default_experience))
    assert_response(:success)
  end

  def test_update
    experience = university_person_experiences(:default_experience)

    assert(experience.description.blank?)
    patch experience_path(experience), params: {
      university_person_experience: {
        description: "Alternance"
      }
    }
    assert_redirected_to(account_path)
    assert_equal("Alternance", experience.reload.description)
  end

end
