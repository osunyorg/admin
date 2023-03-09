class Video::Provider::Dailymotion < Video::Provider::Default
  DOMAINS = ['dailymotion.com', 'dai.ly']

  # "https://www.dailymotion.com/video/x35l6b8"
  # "https://dai.ly/x35l6b8"
  def identifier
    video_url.include?('dai.ly')  ? video_url.split('dai.ly/').last
                                  : video_url.split('video/').last
  end

  # https://developer.dailymotion.com/player#player-parameters
  def iframe_url
    "https://www.dailymotion.com/embed/video/#{identifier}"
  end
end
