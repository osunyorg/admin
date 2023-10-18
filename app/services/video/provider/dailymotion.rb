class Video::Provider::Dailymotion < Video::Provider::Default
  DOMAINS = [
    'dailymotion.com', 
    'www.dailymotion.com', 
    'dai.ly',
    '*.dmcdn.net'
  ]

  def identifier
    video_url.include?('dai.ly')  ? video_url.split('dai.ly/').last
                                  : video_url.split('video/').last
  end

  def csp_domains
    DOMAINS
  end

  # https://www.dailymotion.com/thumbnail/video/x8lyp39
  def poster
    "https://www.dailymotion.com/thumbnail/video/#{identifier}"
  end

  # https://developer.dailymotion.com/player#player-parameters
  def iframe_url
    "https://www.dailymotion.com/embed/video/#{identifier}"
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe_url}?autoplay=1&quality=380"
  end
end
