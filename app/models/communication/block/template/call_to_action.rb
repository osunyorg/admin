class Communication::Block::Template::CallToAction < Communication::Block::Template
  def sanitized_data
    {
      "text" => Osuny::Sanitizer.sanitize(text),
      "url" => url,
      "button" => Osuny::Sanitizer.sanitize(button, 'string'),
      "url_secondary" => url_secondary,
      "button_secondary" => Osuny::Sanitizer.sanitize(button_secondary, 'string'),
      "url_tertiary" => url_tertiary,
      "button_tertiary" => Osuny::Sanitizer.sanitize(button_tertiary, 'string'),
      "image" => data['image'],
      "image_alt" => Osuny::Sanitizer.sanitize(data['image_alt'], 'string'),
      "image_credit" => Osuny::Sanitizer.sanitize(data['image_credit'], 'string')
    }
  end

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
