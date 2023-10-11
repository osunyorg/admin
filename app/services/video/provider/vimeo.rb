class Video::Provider::Vimeo < Video::Provider::Default
  DOMAINS = [
    'vimeo.com',
    'player.vimeo.com',
    'vumbnail.com'
  ]

  def identifier
    video_url.chomp('/').split('/').last
  end

  def csp_domains
    DOMAINS
  end

  # https://vumbnail.com/621585396.jpg
  def poster
    "https://vumbnail.com/#{identifier}.jpg"
  end

  # https://help.vimeo.com/hc/en-us/articles/360001494447-Using-Player-Parameters
  def iframe_url
    "https://player.vimeo.com/video/#{identifier}"
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe_url}?autoplay=1&quality=360p"
  end
end
