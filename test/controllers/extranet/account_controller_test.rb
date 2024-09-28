require "test_helper"

class Extranet::AccountControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_show
    get account_path(lang: french)
    assert_response(:success)
  end

  def test_edit
    get edit_account_path(lang: french)
    assert_response(:success)
  end

  def test_update
    alumnus_person_l10n = alumnus_person.original_localization
    assert_equal("Alumnus", alumnus.first_name)
    assert_equal("Alumnus", alumnus_person_l10n.first_name)
    patch account_path(lang: french), params: { user: { first_name: "New Alumnus" } }
    assert_redirected_to(account_path)
    assert_equal("New Alumnus", alumnus.first_name)
    assert_equal("New Alumnus", alumnus_person_l10n.reload.first_name)
  end

  def test_update_password
    patch account_path(lang: french), params: { user: { password: "NewPassw0rd!" } }
    assert_response(:unprocessable_entity)
  end
end
