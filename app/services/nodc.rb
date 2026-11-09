class Nodc

  def create_bucket(host)
    response = client.post("website/#{host}")
    {
      identifier: response.body.dig('vhost', 'name'),
      access_key_id: response.body.dig('access_key_id'),
      secret_access_key: response.body.dig('secret_access_key')
    }
  end

  def rename_bucket(host, new_identifier)
    params = "{ \"vhost\": \"#{new_identifier}\" }"
    response = client.patch("website/#{host}", params)
    response.status == 200
  end

  def empty_and_delete_bucket(host)
    delete_bucket(host) if empty_bucket(host)
  end

  def empty_bucket(host)
    response = client.get("website/#{host}")
    s3 =  Aws::S3::Resource.new(
            endpoint: 'https://s3.nodc.eu',
            region: 'garage',
            access_key_id: response.body.dig('access_key_id'),
            secret_access_key: response.body.dig('secret_access_key')
          )
    bucket = s3.bucket(host)
    bucket.objects.batch_delete!
    true
  rescue
    false
  end

  def delete_bucket(host)
    response = client.delete("website/#{host}")
    response.status == 200
  end

  protected

  def client
    @client ||= Faraday.new(url: 'https://resourcemanager.nodc.eu/v1/') do |faraday|
      faraday.request :aws_sigv4,
        service: 'resourcemanager',
        region: 'eu',
        access_key_id: ENV['NODC_ACCESS_KEY_ID'],
        secret_access_key: ENV['NODC_SECRET_ACCESS_KEY']

      faraday.response :json
    end
  end

end
