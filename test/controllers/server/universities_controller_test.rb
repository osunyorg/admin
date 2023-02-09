require "test_helper"

class Server::UniversitiesControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    get server_universities_path
    assert_response(:success)
  end

  def test_show
    get server_university_path(universities(:default_university))
    assert_response(:success)
  end

  def test_new
    get new_server_university_path
    assert_response(:success)
  end

  def test_edit
    get edit_server_university_path(universities(:default_university))
    assert_response(:success)
  end

  def test_create
    assert_difference("University.count") do
      post server_universities_path, params: {
        university: {
          name: "Nouvelle université",
          identifier: "my-second-university",
          sms_sender_name: "unitest2",
          default_language_id: languages(:fr).id
        }
      }
      university = University.find_by(identifier: "my-second-university")
      assert_redirected_to(server_university_path(university))
    end
  end

  def test_create_invalid
    assert_no_difference("University.count") do
      post server_universities_path, params: {
        university: {
          name: "Nouvelle université",
          sms_sender_name: "unitest2"
        }
      }
      assert_response(:unprocessable_entity)
    end
  end

  def test_update
    university = universities(:default_university)
    assert_equal "Université de test", university.name
    patch server_university_path(university), params: { university: { name: "Mon université" } }
    assert_redirected_to(server_university_path(university))
    assert_equal "Mon université", university.reload.name
  end

  def test_update_invalid
    university = universities(:default_university)
    patch server_university_path(university), params: { university: { identifier: "" } }
    assert_response(:unprocessable_entity)
  end

  def test_destroy
    assert_difference("University.count", -1) do
      # TODO: Replace by default university with correct dependent: :destroy associations
      delete server_university_path(universities(:stale_university))
      assert_redirected_to(server_universities_path)
    end
  end
end
