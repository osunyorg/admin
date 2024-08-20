class Communication::Block::Template::Link::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :description, :rich_text
  has_component :url, :string
  has_component :image, :image

end
