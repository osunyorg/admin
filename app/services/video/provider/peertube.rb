class Video::Provider::Peertube < Video::Provider::Default
  DOMAINS = [
    'peertube.fr'
  ]

  def identifier
    video_url.split('/w/').last
  end

  # https://docs.joinpeertube.org/support/doc/api/embeds#quick-start
  def iframe_url
    "#{instance}/videos/embed/#{identifier}"
  end

  def correct?
    url_in_domains? || url_looks_like_peertube?
  end

  protected

  def instance
    video_url.split('/w/').first
  end

  def url_looks_like_peertube?
    "/w/".in?(video_url) || "/videos/watch/".in?(video_url)
  end

  # L'autoplay est à 1 uniquement parce que l'iframe n'est pas chargée
  def embed_with_defaults
    "#{iframe_url}?autoplay=1"
  end
end
