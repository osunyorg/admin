class Communication::Block::Component::TimeSlot < Communication::Block::Component::Base

  def self.openapi_property_type
    :object
  end

  def self.openapi_property_additional_properties
    {
      properties: {
        from: { type: :string, format: 'time' },
        to: { type: :string, format: 'time' }
      }
    }
  end

  def from
    data['from']
  end

  def to
    data['to']
  end

  def present?
    from && from != '0' && to && to != '0'
  end

  def blank?
    !present?
  end

  def default_data
    {
      'from' => '',
      'to' => ''
    }
  end

end
