class Communication::Block::Template::Chapter < Communication::Block::Template::Base

  has_rich_text :text
  has_rich_text :notes
  has_image :image
  has_string :alt
  has_rich_text :credit

  protected

  def check_accessibility
    super
    accessibility_warning 'accessibility.commons.alt.empty' if image_component.blob && alt.blank?
  end
end
