class Communication::Block::Template::Image < Communication::Block::Template
  def sanitized_data
    {
      "text" => Osuny::Sanitizer.sanitize(text),
      "image" => data['image'],
      "image_alt" => Osuny::Sanitizer.sanitize(data['image_alt'], 'string'),
      "image_credit" => Osuny::Sanitizer.sanitize(data['image_credit'], 'string')
    }
  end

  def build_git_dependencies
    add_dependency image&.blob
  end

  def image
    extract_image_alt_and_credit data, 'image'
  end

  def text
    "#{data['text']}"
  end

end
