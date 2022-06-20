class Communication::Block::Template::Gallery::Element < Communication::Block::Template::Base
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :text

  def blob
    image_component.blob
  end

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
