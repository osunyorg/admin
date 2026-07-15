class Communication::Block::Component::Array < Communication::Block::Component::Base

  def self.openapi_property_type
    :array
  end

  def self.openapi_property_additional_properties
    { items: { type: :string } }
  end

  def data=(value)
    # Nil values must be turned to ""
    @data = value.map { |s| s.to_s }
  end

  def default_data
    ['']
  end

end
