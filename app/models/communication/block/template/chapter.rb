class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_layouts [:no_background, :alt_background, :accent_background]

  has_component :text, :rich_text
  has_component :notes, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  def media
    image_component.communication_media
  end

  # Permet de gérer les contextes
  def communication_medias
    [media].compact_blank
  end

  def dom_count
    5 +
    text_component.dom_count +
    notes_component.dom_count +
    image_component.dom_count +
    alt_component.dom_count +
    credit_component.dom_count
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end
end
