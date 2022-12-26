class Communication::Block::Template::Definition < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

end
