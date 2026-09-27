# frozen_string_literal: true

# Rack::Attack — protection contre les requêtes abusives.
# https://github.com/rack/rack-attack
#
# Issue #4362 : une requête malveillante avec une query string de ~15 Ko
# provoquait une ActionDispatch::Cookies::CookieOverflow, car Devise
# stockait l'URL complète (chemin + query string) en session sans limite
# de taille. L'attaque tentait aussi une SSRF vers l'endpoint metadata AWS
# (169.254.169.254).

# --- Blocklist (active partout, y compris en test) ----------------------
# On bloque en amont les requêtes dont l'URL dépasse 8 Ko, ce qui est
# bien au-dessus de toute URL légitime (nginx et Apache utilisent 8 Ko
# comme limite par défaut) et bien en-dessous de la limite des 4 Ko du
# cookie de session une fois l'URL chiffrée.
Rack::Attack.blocklist("block oversized requests") do |req|
  req.fullpath.bytesize > 8192
end

# --- Throttling (hors test — nécessite un cache partagé) -----------------
# Devise :lockable verrouille par compte, pas par IP. Un attaquant qui
# rotationne entre les comptes (credential stuffing) ne déclenche jamais
# le verrouillage. Les règles ci-dessous comblent cette lacune.
unless Rails.env.test?
  # Credential stuffing / bruteforce sur la connexion.
  Rack::Attack.throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.post? && req.path == "/users/sign_in" ? req.ip : nil
  end

  # Bruteforce du code 2FA (max_login_attempts = 3 est par compte).
  Rack::Attack.throttle("otp/ip", limit: 5, period: 60.seconds) do |req|
    (req.patch? || req.put?) && req.path == "/users/two_factor_authentication" ? req.ip : nil
  end

  # Email bombing via demande de reset de mot de passe.
  Rack::Attack.throttle("password_reset/ip", limit: 5, period: 60.seconds) do |req|
    req.post? && req.path == "/users/password" ? req.ip : nil
  end

  # SMS/email bombing via renvoi de code 2FA (SMS Brevo = coût réel).
  Rack::Attack.throttle("otp_resend/ip", limit: 3, period: 60.seconds) do |req|
    req.get? && req.path == "/users/two_factor_authentication/resend_code" ? req.ip : nil
  end
end
