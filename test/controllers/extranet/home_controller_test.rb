require "test_helper"

class Extranet::HomeControllerTest < ActionDispatch::IntegrationTest

  def test_index_unknown_context
    get(root_path)
    assert_response(:forbidden)
  end

  def test_index_unauthenticated
    host! "extranet.osuny"
    get(root_path)
    assert_redirected_to(new_user_session_path)
  end

  def test_index
    host! "extranet.osuny"
    sign_in_with_2fa(alumnus)
    get(root_path)
    assert_response(:success)
  end
end
