class Video::Provider::Youtube < Video::Provider::Default
  DOMAINS = ['youtube.com', 'youtu.be']

  # "https://www.youtube.com/watch?v=sN8Cq5HEBug"
  # "https://youtu.be/sN8Cq5HEBug"
  def identifier
    video_url.include?('youtu.be')  ? video_url.split('youtu.be/').last
                                    : video_url.split('v=').last
  end

  # https://developers.google.com/youtube/player_parameters
  def iframe_url
    "https://www.youtube.com/embed/#{identifier}"
  end
end
