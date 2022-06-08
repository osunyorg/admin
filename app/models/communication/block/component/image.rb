class Communication::Block::Component::Image < Communication::Block::Component::Base

  def blob
    return if data['id'].blank?
    @blob ||= template.blob_with_id data['id']
  end

end
