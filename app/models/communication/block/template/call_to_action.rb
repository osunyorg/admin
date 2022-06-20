class Communication::Block::Template::CallToAction < Communication::Block::Template::Base

  has_elements
  has_component :text, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end

end
