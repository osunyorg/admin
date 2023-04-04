class Communication::Block::Template::Feature::Element < Communication::Block::Template::Base

  has_component :image, :image
  has_component :title, :string
  has_component :description, :text

end
