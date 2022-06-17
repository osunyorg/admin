class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :carousel]
  has_component :description, :rich_text

end
