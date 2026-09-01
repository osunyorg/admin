class Communication::Block::Template::Link::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :description, :rich_text
  has_component :url, :string
  has_component :image, :image

  def url_external?(website)
    url.present? &&
    !url.start_with?('/') &&
    !url.start_with?(website.url)
  end

  def empty?
    title.blank? && description.blank? && url.blank?
  end

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
    1 + 
    title_component.dom_count +
    description_component.dom_count +
    url_component.dom_count +
    image_component.dom_count
  end
end
