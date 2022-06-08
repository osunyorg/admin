class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_layouts [:grid, :carousel]
  has_elements Communication::Block::Template::Gallery::Image

end
