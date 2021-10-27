class DownloadService
  attr_reader :response

  def self.download(url)
    new(url)
  end

  def initialize(url)
    @url = url
    process!
  end

  def attachable_data
    { io: io, filename: filename, content_type: content_type }
  end

  def io
    @io ||= StringIO.new(@response.body)
  end

  def filename
    @filename ||= File.basename(@url)
  end

  def content_type
    @content_type ||= @response['Content-Type']
  end

  protected

  def process!
    uri = URI(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    @response = http.request(request)
  end
end