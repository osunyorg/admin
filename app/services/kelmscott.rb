# Étape 2 de https://developers.osuny.org/docs/admin/sites-web/publisher/
# Kelmscott reçoit en une seule requête la demande de build et ses paramètres (étape 3) :
# dépôt, type de synchronisation et variables, avec les secrets déjà chiffrés par sa clé publique.
class Kelmscott
  attr_reader :website

  def initialize(website)
    @website = website
  end

  def publish
    client.post(website.repository, payload.to_json)
  end

  protected

  def payload
    {
      git_url: "#{website.repository_url}.git",
      sync_method: website.kelmscott_sync_method,
      variables: website.variables.pluck(:key, :value).to_h
    }
  end

  def client
    @client ||= Faraday.new url: ENV['KELMSCOTT_URL'],
                            headers: { 'Content-Type' => 'application/json' } do |faraday|
      faraday.request :authorization, 'Bearer', ENV['KELMSCOTT_TOKEN']
    end
  end

end
