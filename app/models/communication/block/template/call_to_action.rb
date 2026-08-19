class Communication::Block::Template::CallToAction < Communication::Block::Template::Base

  has_layouts [
    :accent_background,
    :no_background
  ]

  has_elements
  has_component :text, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end
  
  def top_description
    text
  end

  def media
    image_component.communication_media
  end

  # Permet de gérer les contextes
  def communication_medias
    [media].compact_blank
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
