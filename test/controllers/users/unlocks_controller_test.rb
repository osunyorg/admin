require "test_helper"

class Users::UnlocksControllerTest < ActionDispatch::IntegrationTest

  def test_extranet_unlock_instructions_mail_uses_extranet_host
    host! default_extranet.host
    user = users(:alumnus)

    # Premier test : vérifie le contenue du mail envoyé si on clique sur le lien "Déblocage" depuis l'extranet
    user.lock_access!
    assert user.access_locked?
    
    ActionMailer::Base.deliveries.clear
    
    post user_unlock_path, params: {
      user: {
        email: user.email
      }
    }

    mail = ActionMailer::Base.deliveries.last
    
    assert_not_nil mail
    assert_includes mail.body.encoded, default_extranet.host
    
    # Second test : vérifie le contenu du mail envoyé si on bloque le compte depuis l'extranet en faisant 3 mauvais essais
    user.unlock_access!
    refute user.access_locked?

    ActionMailer::Base.deliveries.clear

    3.times do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "wrong-password"
        },
        hashcash: ActiveHashcash::Stamp.mint(host).to_s
      }
    end

    user.reload
    assert user.access_locked?
    
    mail = ActionMailer::Base.deliveries.last

    assert_not_nil mail
    assert_includes mail.body.encoded, default_extranet.host
  end
end
