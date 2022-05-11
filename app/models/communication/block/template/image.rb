class Communication::Block::Template::Image < Communication::Block::Template
  def build_git_dependencies
    add_dependency image&.blob
  end

  def image
    blob = find_blob data, 'image'
    return if blob.nil?
    {
      blob: blob,
      alt: data['image_alt'],
      credit: data['image_credit']
    }.to_dot
  end

  def text
    "#{data['text']}"
  end

end
