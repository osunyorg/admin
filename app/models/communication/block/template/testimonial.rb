class Communication::Block::Template::Testimonial < Communication::Block::Template
  def build_git_dependencies
    add_dependency photos
  end

  def testimonials
    @testimonials ||= elements.map do |element|
      blob = find_blob element, 'photo'
      element['blob'] = blob if blob
      element
    end
  end

  def photos
    unless @photos
      @photos = []
      testimonials.each do |testimonial|
        @photos << testimonial['blob'] if testimonial.has_key? 'blob'
      end
    end
    @photos
  end
end
