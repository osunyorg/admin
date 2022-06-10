class Communication::Block::Component::Image < Communication::Block::Component::Base

  def blob
    return if data.nil? || data['id'].blank?
    @blob ||= template.blob_with_id data['id']
  end

  def default_data
    {
      'id' => ''
    }
  end

  def active_storage_blobs
    # If blob is nil, compact will remove it and the method will return an empty array
    [blob].compact
  end

end
