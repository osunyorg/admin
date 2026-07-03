class Communication::Block::Component::File < Communication::Block::Component::Base

  def self.openapi_property_type
    :object
  end

  def self.openapi_property_additional_properties
    {
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        filename: { type: :string, nullable: true }
      }
    }
  end

  def blob
    return if data_empty?
    @blob ||= communication_file_localisation&.original_blob
  end

  def communication_file
    return if data_empty?
    @communication_file ||= university.communication_files.find_by(id: data['id'])
  end

  def communication_file_localisation
    return if data_empty?
    @communication_file_localisation ||= communication_file.localization_for(language)
  end

  def default_data
    {
      'id' => ''
    }
  end

  def dependencies
    [
      blob,
      communication_file
    ]
  end

  protected

  def data_empty?
    data.nil? || data['id'].blank?
  end

  def university
    @university ||= template.block.university
  end

  def language
    @language ||= template.block.language
  end
end
