class Communication::Block::Template::Feature::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :description, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  def empty?
    title.blank? && description.blank?
  end

  def dom_count
    2 + 
    description_component.dom_count +
    image_component.dom_count +
    alt_component.dom_count +
    credit_component.dom_count
  end
end
