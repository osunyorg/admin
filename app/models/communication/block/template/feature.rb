class Communication::Block::Template::Feature < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list
  ]
  has_component :description, :rich_text

  has_component :option_icons, :boolean, default: false

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end

  def children
    elements
  end

  # Permet de gérer les contextes
  def communication_medias
    elements.map(&:communication_media).compact_blank
  end

  def crop_settings_for(media)
    element_with_media = data['elements'].detect { |element|
      element.dig('image', 'communication_media_id') == media.id
    }
    element_with_media.dig('image', 'crop_settings') if element_with_media
  end

end
