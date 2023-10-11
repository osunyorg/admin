class Video::Provider::Youtube < Video::Provider::Default
  DOMAINS = [
    'youtube.com', 
    'www.youtube.com', 
    'img.youtube.com', 
    'youtu.be', 
  ]

  def identifier
    video_url.include?('youtu.be')  ? video_url.split('youtu.be/').last
                                    : video_url.split('v=').last
  end

  def csp_domains
    DOMAINS
  end

  # https://img.youtube.com/vi/XEEUOiTgJL0/hqdefault.jpg
  def poster
    "https://img.youtube.com/vi/#{identifier}/hqdefault.jpg"
  end

  # https://developers.google.com/youtube/player_parameters
  def iframe_url
    "https://www.youtube.com/embed/#{identifier}"
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe}?autoplay=1"
  end
end
