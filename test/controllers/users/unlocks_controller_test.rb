require "test_helper"

class Users::UnlocksControllerTest < ActionDispatch::IntegrationTest
  def test_extranet_unlock_instructions_mail_uses_extranet_host
    host! default_extranet.host
    user = users(:alumnus)
    user.lock_access!

    ActionMailer::Base.deliveries.clear

    post user_unlock_path, params: {
      user: {
        email: user.email
      }
    }

    mail = ActionMailer::Base.deliveries.last

    assert_not_nil mail
    assert_includes mail.body.encoded, default_extranet.host
  end
end
