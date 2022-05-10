class Communication::Block::Template::Gallery < Communication::Block::Template
  def build_git_dependencies
    add_dependency active_storage_blobs
  end

  def images_with_data
    @images_with_data ||= elements.map { |element| image_with_data(element) }
                                 .compact
  end

  def active_storage_blobs
    @active_storage_blobs ||=  images_with_data.map { |hash| hash.blob }
                                              .compact
  end

  protected

  def image_with_data(element)
    blob = find_blob element, 'file'
    return if blob.nil?
    {
      blob: blob,
      alt: element['alt'],
      credit: element['credit'],
      text: element['text'],
    }.to_dot
  end
end
