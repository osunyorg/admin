class Plausible

  def create_site(site_id)
    response = client.post("sites", {
      domain: site_id,
      timezone: Time.zone.name
    })
    JSON.parse(response.body)
  end

  def create_shared_link(site_id, name)
    response = client.put("sites/shared-links", { site_id: site_id, name: name })
    JSON.parse(response.body)
  end

  protected

  def client
    unless @client
      @client = Faraday.new url: 'https://plausible.io/api/v1/'
      @client.request :authorization,
                      "Bearer",
                      ENV['PLAUSIBLE_API_KEY']
    end
    @client
  end

end
