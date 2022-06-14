class Communication::Block::Template::Image < Communication::Block::Template::Base

  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text
  has_component :text, :text

end
