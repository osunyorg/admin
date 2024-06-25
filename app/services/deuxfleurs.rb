class Deuxfleurs

  def get_bucket(host)
    call_bucket_endpoint(host, method: :get)
  end

  def create_bucket(host)
    call_bucket_endpoint(host, method: :post)
  end

  def rename_bucket(host, new_identifier)
    params = "{ \"vhost\": \"#{new_identifier}\" }"
    response = client.patch("website/#{host}", params)
    response.status == 200
  end

  protected

  def call_bucket_endpoint(host, method:)
    response = client.public_send(method, "website/#{host}")
    data = JSON.parse response.body
    {
      identifier: data.dig('vhost', 'name'),
      access_key_id: data.dig('access_key_id'),
      secret_access_key: data.dig('secret_access_key')
    }
  end

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