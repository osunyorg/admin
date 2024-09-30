require "test_helper"

class Extranet::PagesControllerTest < ActionDispatch::IntegrationTest
  include ExtranetSetup

  def test_terms
    get terms_path(lang: french)
    assert_response(:success)
  end

  def test_cookies_policy
    get cookies_policy_path(lang: french)
    assert_response(:success)
  end

  def test_privacy_policy
    get privacy_policy_path(lang: french)
    assert_response(:success)
  end

  def test_data
    get data_path(lang: french)
    assert_response(:success)
  end
end
