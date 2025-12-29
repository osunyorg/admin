class Deuxfleurs

  def create_bucket(host)
    response = client.post("website/#{host}")
    data = JSON.parse response.body
    {
      identifier: data.dig('vhost', 'name'),
      access_key_id: data.dig('access_key_id'),
      secret_access_key: data.dig('secret_access_key')
    }
  end

  def rename_bucket(host, new_identifier)
    params = "{ \"vhost\": \"#{new_identifier}\" }"
    response = client.patch("website/#{host}", params)
    response.status == 200
  end

  def empty_bucket(host)
    response = client.get("website/#{host}")
    data = JSON.parse(response.body)
    s3 = Aws::S3::Resource.new(
            endpoint: 'https://garage.deuxfleurs.fr',
            region: 'garage', 
            access_key_id: data.dig('access_key_id'), 
            secret_access_key: data.dig('secret_access_key')
          )
    bucket = s3.bucket(host)
    bucket.objects.batch_delete!
  end

  def delete_bucket(host)
    response = client.delete("website/#{host}")
    response.status == 200
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