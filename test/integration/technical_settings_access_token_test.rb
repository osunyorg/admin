require "test_helper"

class TechnicalSettingsAccessTokenTest < ActionDispatch::IntegrationTest
  test "a freshly typed access_token is not lost when another field fails validation" do
    sign_in_with_2fa admin
    website = website_with_gitlab
    website.update_column(:access_token, nil)
    Communication::Website.define_singleton_method(:organized_for) { |*| [] }

    patch admin_communication_website_path(id: website.id, lang: french.iso_code),
          params: {
            _return_to: 'technical',
            communication_website: {
              repository: 'not-a-valid-repo-format',
              access_token: 'freshly-typed-token'
            }
          }

    assert_response :unprocessable_content
    assert_match 'value="freshly-typed-token"', response.body
    assert_nil website.reload.access_token
  end

  test "the access_token field stays empty on a normal page load, even with an existing token" do
    sign_in_with_2fa admin
    website = website_with_gitlab
    website.update_column(:access_token, 'some-existing-token')
    Communication::Website.define_singleton_method(:organized_for) { |*| [] }

    get technical_admin_communication_website_path(id: website.id, lang: french.iso_code)

    assert_response :success
    refute_match 'value="some-existing-token"', response.body
  end
end
