class Communication::Block::Template::Link::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :alt_title, :string
  has_component :description, :rich_text
  has_component :url, :string
  has_component :image, :image

  def check_accessibility
    super
    accessibility_warning 'accessibility.blocks.templates.links.alt_title_missing' if alt_title.blank?
  end

end
