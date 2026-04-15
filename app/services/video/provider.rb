class Video::Provider
  PROVIDERS = [
    Arte,
    Canalu,
    Vimeo,
    Youtube,
    Dailymotion,
    Peertube # Comes last because detection is less reliable
  ]

  # Block is sent to cache metadata 
  def self.find(video_url, block)
    PROVIDERS.each do |provider_class|
      provider = provider_class.new(video_url, block)
      return provider if provider.correct?
    end
    Default.new(video_url)
  end
end
