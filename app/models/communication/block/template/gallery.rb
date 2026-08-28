class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :carousel, :large]
  has_component :description, :rich_text

  def empty?
    communication_medias.none?
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
