class Video::Provider::Youtube < Video::Provider::Default
  DOMAINS = ['youtube.com', 'youtu.be']

  def identifier
    video_url.include?('youtu.be')  ? identifier_path
                                    : identifier_param
  end

  # https://img.youtube.com/vi/XEEUOiTgJL0/hqdefault.jpg
  def poster
    "https://img.youtube.com/vi/#{identifier}/hqdefault.jpg"
  end

  # https://developers.google.com/youtube/player_parameters
  def iframe_url
    "https://www.youtube.com/embed/#{identifier}"
  end

  protected

  def identifier_path
    video_url.split('youtu.be/').last
  end

  def identifier_param
    uri = URI(video_url)
    params = CGI::parse(uri.query)
    params['v'].first
  end
end
