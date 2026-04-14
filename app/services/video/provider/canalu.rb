class Video::Provider::Canalu < Video::Provider::Default
  DOMAINS = [
    'canal-u.tv'
  ]

  def identifier
    unless @identifier
      if oembed['html']
        @identifier = oembed['html'].split('embed/').last.split('?').first
      end
    end
    @identifier
  end

  def csp_domains
    DOMAINS
  end

  # https://vod.canal-u.tv/videos/2026/04/112669/iran_entre_deux_feu-vf-1.jpg
  def poster
    oembed['thumbnail_url']
  end

  # https://www.canal-u.tv/embed/174500
  def iframe_url
    "https://www.canal-u.tv/embed/#{identifier}"
  end

  def oembed
    unless @oembed
      begin
        io = URI.parse(oembed_url).open
        @oembed = JSON.load(io)
      rescue
        @oembed = {}
      end
    end
    @oembed
  end

  def title
    oembed['title']
  end

  protected

  def oembed_url
    "https://www.canal-u.tv/oembed?format=json&url=#{video_url}"
  end
end
