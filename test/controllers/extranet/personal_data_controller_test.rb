require "test_helper"

class Extranet::PersonalDataControllerTest < ActionDispatch::IntegrationTest
  def setup
    host! "extranet.osuny"
    sign_in_with_2fa(alumnus)
  end

  def test_edit
    get edit_personal_data_path
    assert_response(:success)
  end

  def test_update
    assert(alumnus_person.biography.blank?)
    patch personal_data_path, params: { university_person: { biography: "<p>Je suis un ancien étudiant.</p>" } }
    assert_redirected_to(account_path)
    assert(alumnus_person.reload.biography.to_s.include?("Je suis un ancien étudiant."))
  end
end
