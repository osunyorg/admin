class Communication::Block::Template::Timeline::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :text, :rich_text

end
