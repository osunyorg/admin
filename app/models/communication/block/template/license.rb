class Communication::Block::Template::License < Communication::Block::Template::Base
  has_component :description, :rich_text
  has_component :type, :option, options: [:creative_commons]
  has_component :creative_commons_attribution, :option, options: [:false, :true]
  has_component :creative_commons_commercial_use, :option, options: [:true, :false]
  has_component :creative_commons_derivatives, :option, options: [:true, :false]
  has_component :creative_commons_sharing, :option, options: [:true, :false]
end
