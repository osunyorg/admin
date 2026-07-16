class Communication::Block::Template::KeyFigure::Element < Communication::Block::Template::Base

  has_component :number, :number
  has_component :unit, :string
  has_component :description, :string
  has_component :image, :image

  def blob
    image_component.blob
  end

  def dom_count
    5 +
    image_component.dom_count
  end
end
