class Communication::Block::Template::Gallery::Element < Communication::Block::Template::Base
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :rich_text

  def blob
    image_component.blob
  end

  def communication_media
    image_component.communication_media
  end

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

  def empty?
    blob.blank?
  end

  def dom_count
    image_component.dom_count +
    alt_component.dom_count +
    credit_component.dom_count +
    text_component.dom_count
  end
end
