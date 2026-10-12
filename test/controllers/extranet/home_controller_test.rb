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

  # Regression test for issue #4362.
  # A malicious request with a very large query string must not overflow
  # the 4 KB session cookie (which raised ActionDispatch::Cookies::CookieOverflow).
  # The real attack also embedded an SSRF payload targeting the AWS metadata
  # endpoint (169.254.169.254). Rack::Attack blocks the request upstream
  # before Devise stores the oversized URL in session.
  def test_root_unauthenticated_with_huge_param_is_blocked
    host! default_extranet.host
    get(root_path, params: { unix: "A" * 15_000 })
    assert_response(:forbidden)
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
