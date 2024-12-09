class Communication::Block::Component::File < Communication::Block::Component::Base

  def self.openapi_property_type
    :object
  end

  def self.openapi_property_additional_properties
    {
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        filename: { type: :string, nullable: true },
        signed_id: { type: :string, nullable: true }
      }
    }
  end

  def blob
    return if data.nil? || data['id'].blank?
    @blob ||= template.block
                      .university
                      .active_storage_blobs
                      .find_by id: data['id']
  end

  def default_data
    {
      'id' => ''
    }
  end

  def dependencies
    [blob]
  end

end
