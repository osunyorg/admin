class Communication::Block::Component::Number < Communication::Block::Component::Base

  def self.openapi_property_type
    :number
  end

  def default_data
    @default || 0
  end

end
