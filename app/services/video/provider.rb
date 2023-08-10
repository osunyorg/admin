class Video::Provider
  PROVIDERS = [
    Vimeo,
    Youtube,
    Dailymotion,
    Peertube
  ]

  def self.find(video_url)
    PROVIDERS.each do |provider|
      return provider.new(video_url) if url_in_domains?(video_url, provider::DOMAINS)
    end
    Default.new(video_url)
  end

  protected

  def self.url_in_domains?(url, domains)
    domains.any? { |domain| url.include? domain }
  end
end
