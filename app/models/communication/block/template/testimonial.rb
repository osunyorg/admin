class Communication::Block::Template::Testimonial < Communication::Block::Template
  def build_git_dependencies
    add_dependency photos
  end

  def testimonials
    @testimonials ||= elements.map { |element| testimonial(element) }
                              .compact
  end

  protected

  def photos
    @photos ||= testimonials.map { |testimonial| testimonial.blob }
                            .compact
  end

  def testimonial(element)
    blob = find_blob element, 'photo'
    element['blob'] = blob
    element.to_dot
  end
end
