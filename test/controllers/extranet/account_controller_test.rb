require "test_helper"

class Extranet::AccountControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_show
    get account_path
    assert_response(:success)
  end

  def test_edit
    get edit_account_path
    assert_response(:success)
  end

  def test_update
    assert_equal("Alumnus", alumnus.first_name)
    patch account_path, params: { user: { first_name: "New Alumnus" } }
    assert_redirected_to(account_path)
    assert_equal("New Alumnus", alumnus.first_name)
  end

  def test_update_password
    patch account_path, params: { user: { password: "NewPassw0rd!" } }
    assert_redirected_to(account_path)
  end
end
