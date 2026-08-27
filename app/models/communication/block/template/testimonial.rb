class Communication::Block::Template::Testimonial < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :carousel,
    :grid,
    :list,
    :large
  ]

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end

  def top_screen_reader_only
    true
  end

  def children
    elements
  end

  # Permet de gérer les contextes
  def communication_medias
    elements.map(&:communication_media).compact_blank
  end

  def dom_count
    5 +
    children.sum(&:dom_count)
  end

  def crop_settings_for(media)
    element_with_media = data['elements'].detect { |element|
      element.dig('photo', 'communication_media_id') == media.id
    }
    element_with_media.dig('photo', 'crop_settings') if element_with_media
  end
end
