require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  ActiveHashcash.bits = 2

  def test_extranet_create
    host! default_extranet.host
    default_extranet.connect(olivia)
    post user_registration_path, params: {
      user: {
        email: olivia.email,
        first_name: "Olivia",
        last_name: "Simonet",
        password: "MyP4ssw0rd!",
        password_confirmation: "MyP4ssw0rd!",
        language_id: french.id
      },
      hashcash: ActiveHashcash::Stamp.mint(host).to_s
    }
    assert_redirected_to root_path
    user = User.find_by(email: olivia.email)
    assert_equal(olivia, user.person)
    put user_two_factor_authentication_path, params: {
      code: user.direct_otp
    }
    assert_redirected_to root_path
    get extranet_root_path(lang: french.iso_code)
    assert_response :success
  end
end
