class Communication::Block::Component::File < Communication::Block::Component::Base

  def self.openapi_property_type
    :object
  end

  def self.openapi_property_additional_properties
    {
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        communication_file_id: { type: :string, format: :uuid, nullable: true },
        filename: { type: :string, nullable: true }
      }
    }
  end

  def blob
    return if data_empty?
    @blob ||= communication_file_localization&.original_blob
  end

  def communication_file_id
    data['communication_file_id']
  end

  def communication_file
    return if data_empty?
    @communication_file ||= university.communication_files.find_by(id: communication_file_id)
  end

  def communication_file_localization
    return if data_empty?
    @communication_file_localization ||= communication_file.localization_for(language)
  end

  def default_data
    {
      'id' => '', # Legacy active storage blob id
      'communication_file_id' => '' # New file id
    }
  end

  def dependencies
    [
      blob,
      communication_file
    ]
  end
  
  def dom_count
    5
  end

  protected

  def data_empty?
    data.nil? || data['communication_file_id'].blank?
  end

  def university
    @university ||= template.block.university
  end

  def language
    @language ||= template.block.language
  end

end
