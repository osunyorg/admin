require "test_helper"

class Extranet::PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    host! "extranet.osuny"
    sign_in_with_2fa(alumnus)
  end

  def test_terms
    get terms_path
    assert_response(:success)
  end

  def test_cookies_policy
    get cookies_policy_path
    assert_response(:success)
  end

  def test_privacy_policy
    get privacy_policy_path
    assert_response(:success)
  end

  def test_data
    get data_path
    assert_response(:success)
  end
end
