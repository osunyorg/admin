class Communication::Block::Template::KeyFigure::Element < Communication::Block::Template::Base

  has_component :number, :number
  has_component :unit, :string
  has_component :description, :string
  has_component :image, :image

  def blob
    image_component.blob
  end

  def communication_media
    image_component.communication_media
  end

  def communication_media_l10n
    communication_media.localization_for(block.language)
  end

  def dom_count
    5 +
    image_component.dom_count
  end
end
