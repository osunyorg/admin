class Video::Provider::Peertube < Video::Provider::Default
  DOMAINS = ['peertube.fr', 'peertude.my.noesya.coop']

  # "https://peertube.fr/w/1i848Qvi7Q3ytW2uPY8AxG"
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
end
