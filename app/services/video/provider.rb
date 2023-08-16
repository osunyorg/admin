class Video::Provider
  PROVIDERS = [
    Vimeo,
    Youtube,
    Dailymotion,
    Peertube # Comes last because detection is less reliable
  ]

  def self.find(video_url)
    PROVIDERS.each do |provider_class|
      provider = provider_class.new(video_url)
      return provider if provider.correct?
    end
    Default.new(video_url)
  end
end
