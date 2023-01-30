require "test_helper"

class Extranet::HomeControllerTest < ActionDispatch::IntegrationTest
  def test_index_unknown_context
    host! "example.com"
    get(root_path)
    assert_response(:forbidden)
  end

  def test_index_unauthenticated
    host! default_extranet.host
    get(root_path)
    assert_redirected_to(new_user_session_path)
  end

  def test_index
    host! default_extranet.host
    sign_in_with_2fa(alumnus)
    get(root_path)
    assert_response(:success)
  end
end
