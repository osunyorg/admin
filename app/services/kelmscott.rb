# Demande de compilation, https://developers.osuny.org/docs/admin/sites-web/kelmscott/
# Kelmscott reçoit en une seule requête la demande et ses paramètres :
# dépôt, type de synchronisation et variables, avec les secrets déjà chiffrés par sa clé publique.
# La demande est signée avec la clé privée de l'admin. 
# Kelmscott, qui n'a que la clé publique, vérifie qu'elle vient bien de l'admin et qu'elle est récente.
class Kelmscott
  attr_reader :website

  def initialize(website)
    @website = website
  end

  def publish
    body = payload.to_json
    timestamp = Time.now.to_i.to_s
    client.post website.kelmscott_path, body, {
      'X-Kelmscott-Timestamp' => timestamp,
      'X-Kelmscott-Signature' => signature(timestamp, body)
    }
  end

  protected

  def payload
    {
      git_url: "#{website.repository_url}.git",
      sync_method: website.kelmscott_sync_method,
      variables: website.variables.pluck(:key, :value).to_h
    }
  end

  # Signée en octets (.b) : avec une chaîne UTF-8, RbNaCl tronque la signature par caractères
  def signature(timestamp, body)
    message = "#{timestamp}\nPOST #{website.kelmscott_path}\n#{body}"
    Base64.strict_encode64(signing_key.sign(message.b))
  end

  def signing_key
    RbNaCl::SigningKey.new(Base64.strict_decode64(ENV['KELMSCOTT_SIGNING_KEY']))
  end

  # HTTPS obligatoire, y compris en développement : les paramètres non secrets (hôtes, utilisateurs, chemins)
  # ne sont protégés que par TLS pendant le transport
  def client
    raise ArgumentError, 'KELMSCOTT_URL must use https' unless URI.parse(ENV['KELMSCOTT_URL'].to_s).scheme == 'https'
    @client ||= Faraday.new url: ENV['KELMSCOTT_URL'],
                            headers: { 'Content-Type' => 'application/json' }
  end

end
