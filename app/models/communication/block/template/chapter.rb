class Communication::Block::Template::Chapter < Communication::Block::Template
  has_rich_text :text
  has_rich_text :notes
  has_image :image

  def build_git_dependencies
    add_dependency image&.blob
  end

  def image
    extract_image_alt_and_credit data, 'image'
  end
end
