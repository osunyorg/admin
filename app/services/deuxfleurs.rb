class Deuxfleurs

  def create_bucket(host)
    response = client.post("website/#{host}")
    data = JSON.parse response.body
    data.dig('vhost', 'name')
  end

  def rename_bucket(host, new_identifier)
    params = "{ \"vhost\": \"#{new_identifier}\" }"
    response = client.patch("website/#{host}", params)
    response.status == 200
  end

  def default_url_for(host)
    "https://#{host}.web.deuxfleurs.fr"
  end

  protected

  def client
    unless @client
      @client = Faraday.new url: 'https://guichet.deuxfleurs.fr/api/unstable/'
      @client.request :authorization, 
                      :basic, 
                      ENV['DEUXFLEURS_USER'], 
                      ENV['DEUXFLEURS_PASSWORD']
    end
    @client
  end

end