class Video::Provider::Youtube < Video::Provider::Default
  DOMAINS = [
    'youtube.com',
    'www.youtube.com',
    'img.youtube.com',
    'youtu.be',
    'youtube-nocookie.com',
    'www.youtube-nocookie.com',
  ]

  def identifier
    if short_url?
      param_from_short_url
    elsif live_url?
      param_from_live_url
    else
      param_from_regular_url
    end
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
    "https://www.youtube-nocookie.com/embed/#{identifier}"
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe_url}?autoplay=1&modestbranding=1&rel=0"
  end

  # https://noembed.com
  def title
    url = "https://noembed.com/embed?dataType=json&url=https://www.youtube.com/watch?v=#{identifier}"
    opened = URI.open(url)
    json = JSON.load(opened)
    json['title']
  rescue
  end

  protected

  def short_url?
    video_url.include?('youtu.be')
  end

  # youtu.be
  def param_from_short_url
    video_url.split('youtu.be/').last
             .split('?').first
  end

  def live_url?
    video_url.include?('/live/')
  end

  # https://www.youtube.com/live/n4jqeyBnuHM?si=RkjPzgQ_lJm7YlTh
  def param_from_live_url
    video_url.split('/live/').last
             .split('?').first
  end
  
  # youtube.com, www.youtube.com
  def param_from_regular_url
    uri = URI(video_url)
    params = CGI::parse(uri.query)
    params['v'].first
  end
end
