class Communication::Block::Template::CallToAction::Element < Communication::Block::Template::Base

  has_component :title, :string
  has_component :url, :string
  has_component :target_blank, :boolean

end
