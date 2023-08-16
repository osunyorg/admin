class Video::Provider::Peertube < Video::Provider::Default
  DOMAINS = ['peertube.fr']

  def identifier
    video_url.split('/w/').last
  end

  def host
    video_url.split('/w/').first
  end

  # https://docs.joinpeertube.org/support/doc/api/embeds#quick-start
  def iframe_url
    "#{host}/videos/embed/#{identifier}"
  end

  def correct?
    url_in_domains? || url_looks_like_peertube?
  end

  protected

  def url_looks_like_peertube?
    "/w/".in?(video_url) || "/videos/watch/".in?(video_url)
  end
end
