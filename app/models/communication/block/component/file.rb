class Communication::Block::Component::File < Communication::Block::Component::Base

  def blob
    return if data.nil? || data['id'].blank?
    @blob ||= template.blob_with_id data['id']
  end

  def default_data
    {
      'id' => ''
    }
  end

  def git_dependencies
    [blob]
  end

end
