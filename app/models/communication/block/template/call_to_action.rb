class Communication::Block::Template::CallToAction < Communication::Block::Template::Base
  def sanitized_data
    {
      "text" => Osuny::Sanitizer.sanitize(text),
      "button" => Osuny::Sanitizer.sanitize(button, 'string'),
      "button_secondary" => Osuny::Sanitizer.sanitize(button_secondary, 'string'),
      "button_tertiary" => Osuny::Sanitizer.sanitize(button_tertiary, 'string'),
      "url" => url,
      "url_secondary" => url_secondary,
      "url_tertiary" => url_tertiary,
      "target_blank" => target_blank,
      "target_blank_secondary" => target_blank_secondary,
      "target_blank_tertiary" => target_blank_tertiary,
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

  def target_blank
    data['target_blank'] == true
  end

  def url_secondary
    "#{data['url_secondary']}"
  end

  def button_secondary
    "#{data['button_secondary']}"
  end

  def target_blank_secondary
    data['target_blank_secondary'] == true
  end

  def url_tertiary
    "#{data['url_tertiary']}"
  end

  def target_blank_tertiary
    data['target_blank_tertiary'] == true
  end

  def button_tertiary
    "#{data['button_tertiary']}"
  end

  def image
    extract_image_alt_and_credit data, 'image'
  end
end
