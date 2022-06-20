class Communication::Block::Template::KeyFigure::Element < Communication::Block::Template::Base

  has_component :number, :number
  has_component :unit, :string
  has_component :description, :text

end
