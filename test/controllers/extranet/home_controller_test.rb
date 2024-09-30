require "test_helper"

class Extranet::HomeControllerTest < ActionDispatch::IntegrationTest
  # root_path has no language and goes to "redirect_to_default_language" action.
  # index is extranet_root_path with lang parameter.

  def test_root_unknown_context
    host! "example.com"
    get(root_path)
    assert_response(:forbidden)
  end

  def test_root_unauthenticated
    host! default_extranet.host
    get(root_path)
    assert_redirected_to(new_user_session_path)
  end

  def test_root
    host! default_extranet.host
    sign_in_with_2fa(alumnus)
    get(root_path)
    assert_redirected_to(extranet_root_path(lang: french))
  end

  def test_index
    host! default_extranet.host
    sign_in_with_2fa(alumnus)
    get(extranet_root_path(lang: french))
    assert_response(:success)
  end
end
