class Video::Provider::Canalu < Video::Provider::Default
  DOMAINS = [
    'canal-u.tv',
    'www.canal-u.tv',
    'vod.canal-u.tv'
  ]

  def identifier
    @identifier ||= find_identifier_in_oembed
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
    @oembed ||= oembed_cached? ? oembed_read_from_cache : oembed_load_and_cache!
  end

  def title
    oembed['title']
  end

  protected

  def find_identifier_in_oembed
    oembed['html'].split('embed/').last.split('?').first
  rescue
    ''
  end

  def oembed_load_and_cache!
    begin
      io = URI.parse(oembed_url).open
      oembed = JSON.load(io)
      oembed_write_to_cache!(oembed)
      oembed
    rescue
      {}
    end
  end

  def oembed_cached?
    # Block provided
    block.present? &&
    # Cache set
    block.metadata.present? && 
    # With video url
    block.metadata.has_key?('video_url') &&
    # Same url
    block.metadata['video_url'] == video_url
  end

  def oembed_write_to_cache!(embed)
    return unless block
    metadata = {
      video_url: video_url,
      oembed: oembed
    }
    block.update_column :metadata, metadata
  end

  def oembed_read_from_cache
    block.metadata['oembed']
  end

  def oembed_url
    "https://www.canal-u.tv/oembed?format=json&url=#{video_url}"
  end
end
