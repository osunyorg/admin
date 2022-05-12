class Communication::Block::Template::CallToAction < Communication::Block::Template
  def build_git_dependencies
    add_dependency image&.blob
  end

  def text
    "#{data['text']}"
  end

  def url
    "#{data['url']}"
  end

  def button
    "#{data['button']}"
  end

  def url_secondary
    "#{data['url_secondary']}"
  end

  def button_secondary
    "#{data['button_secondary']}"
  end

  def url_tertiary
    "#{data['url_tertiary']}"
  end

  def button_tertiary
    "#{data['button_tertiary']}"
  end

  def image
    extract_image_alt_and_credit data, 'image'
  end
end
