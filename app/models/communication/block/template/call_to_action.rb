class Communication::Block::Template::CallToAction < Communication::Block::Template::Base

  has_rich_text :text
  has_image :image
  has_string :alt
  has_string :credit

  has_elements Communication::Block::Template::CallToAction::Button

end
