class Communication::Block::Component::Image < Communication::Block::Component::Base

  def self.openapi_property_type
    :object
  end

  def self.openapi_property_additional_properties
    {
      properties: {
        id: { type: :string, format: :uuid, nullable: true },
        communication_media_id: { type: :string, format: :uuid, nullable: true },
        filename: { type: :string, nullable: true },
        signed_id: { type: :string, nullable: true }
      }
    }
  end

  def blob
    return if data_empty? || !published?
    @blob ||= communication_media_context.active_storage_blob
  end

  def communication_media_context
    return if data_empty?
    @communication_media_context ||= communication_media.context_for(template.block)
  end

  def communication_media_id
    data['communication_media_id']
  end

  def communication_media
    return if data_empty?
    @communication_media ||= university.communication_medias.find_by(id: communication_media_id)
  end

  def communication_media_localization
    return if data_empty?
    @communication_media_localization ||= communication_media.localization_for(language)
  end

  def published?
    communication_media_localization&.published
  end

  def default_data
    {
      'id' => '', # Legacy active storage blob id
      'communication_media_id' => '' # New media id
    }
  end

  def dependencies
    [blob]
  end

  def dom_count
    9
  end

  protected

  def data_empty?
    data.nil? || data['communication_media_id'].blank?
  end

end
