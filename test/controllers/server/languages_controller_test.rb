require "test_helper"

class Server::LanguagesControllerTest < ActionDispatch::IntegrationTest
  include ServerSetup

  def test_index
    get server_languages_path
    assert_response(:success)
  end

  def test_show
    get server_language_path(languages(:fr))
    assert_response(:success)
  end

  def test_new
    get new_server_language_path
    assert_response(:success)
  end

  def test_edit
    get edit_server_language_path(languages(:fr))
    assert_response(:success)
  end

  def test_create
    assert_difference("Language.count") do
      post server_languages_path, params: {
        language: {
          name: "Español",
          iso_code: "es"
        }
      }
      language = Language.find_by(iso_code: "es")
      assert_redirected_to(server_language_path(language))
    end
  end

  def test_create_invalid
    assert_no_difference("Language.count") do
      post server_languages_path, params: {
        language: {
          name: "Français",
          iso_code: "fr"
        }
      }
      assert_response(:unprocessable_entity)
    end
  end

  def test_update
    language = languages(:fr)
    assert(language.summernote_locale.blank?)
    patch server_language_path(language), params: { language: { summernote_locale: "fr-FR" } }
    assert_redirected_to(server_language_path(language))
    assert_equal "fr-FR", language.reload.summernote_locale
  end

  def test_update_invalid
    language = languages(:fr)
    patch server_language_path(language), params: { language: { iso_code: "" } }
    assert_response(:unprocessable_entity)
  end

  def test_destroy
    assert_difference("Language.count", -1) do
      delete server_language_path(languages(:it))
      assert_redirected_to(server_languages_path)
    end
  end
end
