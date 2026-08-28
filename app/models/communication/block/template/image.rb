class Communication::Block::Template::Image < Communication::Block::Template::Base

  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :rich_text

  def empty?
    media.nil?
  end

  def media
    image_component.communication_media
  end

  # Permet de gérer les contextes
  def communication_medias
    [media].compact_blank
  end

  def crop_settings_for(media)
    data.dig('image', 'crop_settings')
  end

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
