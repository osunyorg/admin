class Communication::Block::Template::Gallery < Communication::Block::Template
  def build_git_dependencies
    add_dependency images
  end

  def images_with_alt
    unless @images_with_alt
      @images_with_alt = []
      elements.each do |element|
        @images_with_alt << image_with_alt(element)
      end
      @images_with_alt.compact!
    end
    @images_with_alt
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
