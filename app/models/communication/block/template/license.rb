class Communication::Block::Template::License < Communication::Block::Template::Base
  has_component :kind, :option, options: [:creative_commons]
  has_component :creative_commons, :hash
end
