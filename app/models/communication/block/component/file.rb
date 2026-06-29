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
    @blob ||= university.active_storage_blobs.find_by(id: data['id'])
  end

  def communication_file
    return if data.nil? || data['communication_file_id'].blank?
    @communication_file ||= university.communication_file.find_by(id: data['communication_file_id'])
  end

  def communication_file_localisation
    @communication_file_localisation ||= communication_file.localization_for(language)
  end

  def default_data
    {
      'id' => '',
      'communication_file_id' => ''
    }
  end

  def dependencies
    [
      blob,
      communication_file
    ]
  end

  protected

  def university
    @university ||= template.block.university
  end

  def language
    @lanuage ||= block.language
  end
end
