class Communication::Block::Template::Definition::Element < Communication::Block::Template::Base
  has_component :title, :string
  has_component :description, :text
end
