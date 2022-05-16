class Communication::Block::Template::Chapter < Communication::Block::Template
  def build_git_dependencies
    add_dependency image&.blob
  end

  def image
    extract_image_alt_and_credit data, 'image'
  end

  def text
    "#{data['text']}"
  end

  def notes
    "#{data['notes']}"
  end
end
