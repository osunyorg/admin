class Communication::Block::Template::Gallery < Communication::Block::Template
  def build_git_dependencies
    add_dependency images
  end

  def images_with_alt
    @images_with_alt ||= elements.map { |element| image_with_alt(element) }
                                 .compact
  end

  protected

  def image_with_alt(element)
    blob = find_blob element, 'file'
    return if blob.nil?
    {
      blob: blob,
      alt: element['alt']
    }.to_dot
  end

  def images
    @images ||= images_with_alt.map { |hash| hash.blob }
  end
end
