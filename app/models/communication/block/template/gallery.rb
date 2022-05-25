class Communication::Block::Template::Gallery < Communication::Block::Template
  LAYOUTS = [
    :grid,
    :carousel
  ]

  def build_git_dependencies
    add_dependency active_storage_blobs
  end

  def images_with_alt
    @images_with_alt ||= elements.map { |element|
      extract_image_alt_and_credit element, 'file'
    }.compact
  end

  def active_storage_blobs
    @active_storage_blobs ||=  images_with_alt.map { |hash| hash.blob }
                                              .compact
  end
end
