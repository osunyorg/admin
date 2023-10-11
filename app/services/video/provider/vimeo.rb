class Video::Provider::Vimeo < Video::Provider::Default
  DOMAINS = ['vimeo.com']

  def identifier
    video_url.chomp('/').split('/').last
  end

  # https://vumbnail.com/621585396.jpg
  def poster
    "https://vumbnail.com/#{identifier}.jpg"
  end

  # https://help.vimeo.com/hc/en-us/articles/360001494447-Using-Player-Parameters
  def iframe_url
    "https://player.vimeo.com/video/#{identifier}"
  end
end
