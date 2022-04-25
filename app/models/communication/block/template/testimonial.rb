class Communication::Block::Template::Testimonial < Communication::Block::Template
  def build_git_dependencies
    add_dependency active_storage_blobs
  end

  def testimonials
    @testimonials ||= elements.map { |element| testimonial(element) }
                              .compact
  end

  def active_storage_blobs
    @active_storage_blobs ||= testimonials.map { |testimonial| testimonial.blob }
                                          .compact
  end

  protected

  def testimonial(element)
    blob = find_blob element, 'photo'
    element['blob'] = blob
    element.to_dot
  end
end
