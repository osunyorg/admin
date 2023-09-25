class Deuxfleurs

  def create_bucket(host)
    result = client.create_bucket bucket: host
    result
  end

  protected

  def client
    @client ||= Aws::S3::Client.new access_key_id: ENV['DEUXFLEURS_ACCESS_KEY'], 
                                    secret_access_key: ENV['DEUXFLEURS_SECRET'],
                                    region: 'garage',
                                    endpoint: 'https://garage.deuxfleurs.fr'
  end

end