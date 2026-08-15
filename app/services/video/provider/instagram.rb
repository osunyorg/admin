class Video::Provider::Instagram < Video::Provider::Default
  DOMAINS = [
    'instagram.com',
    'www.instagram.com'
  ]

  def csp_domains
    DOMAINS
  end

  # https://www.instagram.com/reel/DZMwtovSJn4
  def identifier
    video_url.split('reel/').last.split('/').first
  end

  def iframe_tag(**iframe_options)
    raw (blockquote + script)
  end

  def iframe_preview_tag(**iframe_options)
    iframe_tag
  end

  def script
    "<script async src=\"https://www.instagram.com/embed.js\"></script>"
  end

  protected

  def blockquote
    "<blockquote class=\"instagram-media\" data-instgrm-permalink=\"#{video_url}\" data-instgrm-version=\"14\"></blockquote>"
  end
end
