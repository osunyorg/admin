class Video::Provider::Arte < Video::Provider::Default
  DOMAINS = [
    'arte.tv'
  ]

  # https://www.arte.tv/fr/videos/121417-001-A/lala-ce/
  def identifier
    video_url.split('videos/').last.split('/').first
  end

  def language
    video_url.split('arte.tv/').last.split('/').first
  end

  def csp_domains
    DOMAINS
  end

  def poster
    data_from_api['data']['attributes']['metadata']['images'].first['url']
  rescue
  end

  # <iframe title="Lala&#x20;&amp;ce" allowfullscreen="true" style="transition-duration:0;transition-property:no;margin:0 auto;position:relative;display:block;background-color:#000000;" frameborder="0" scrolling="no" width="100%" height="100%" src="https://www.arte.tv/embeds/fr/121417-001-A?autoplay=true&mute=0"></iframe>
  def iframe_url
    "https://www.arte.tv/embeds/#{language}/#{identifier}"
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe_url}?autoplay=true&mute=0"
  end

  def title
    data_from_api['data']['attributes']['metadata']['title']
  rescue
  end

  protected

  def data_from_api
    unless @data_from_api
      url = "https://api.arte.tv/api/player/v2/config/#{language}/#{identifier}/"
      io = URI.parse(url).open
      @data_from_api = JSON.load(io)
    end
    @data_from_api
  end
end
