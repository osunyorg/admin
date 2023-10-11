class Video::Provider::Dailymotion < Video::Provider::Default
  DOMAINS = [
    'dailymotion.com', 
    'dai.ly'
  ]

  def identifier
    video_url.include?('dai.ly')  ? video_url.split('dai.ly/').last
                                  : video_url.split('video/').last
  end

  def csp_domains
    DOMAINS
  end

  # https://www.dailymotion.com/thumbnail/video/x8lyp39
  def poster
    "https://www.dailymotion.com/thumbnail/video/#{identifier}"
  end

  # https://developer.dailymotion.com/player#player-parameters
  def iframe_url
    "https://www.dailymotion.com/embed/video/#{identifier}"
  end
end
