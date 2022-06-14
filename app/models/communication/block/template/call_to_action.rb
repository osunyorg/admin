class Communication::Block::Template::CallToAction < Communication::Block::Template::Base

  has_component :text, :rich_text
  has_component :image, :image
  has_component :alt, :string
  has_component :credit, :rich_text

  has_elements Communication::Block::Template::CallToAction::Button

end
