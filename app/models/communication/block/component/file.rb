class Communication::Block::Component::File < Communication::Block::Component::Base

  def blob
    return if data.nil? || data['id'].blank?
    @blob ||= template.blob_with_id data['id']
  end

  def data=(value)
    super
    # Fix nil objects
    @data = {} if @data.nil?
    # Fix objects with no id
    @data['id'] = '' unless @data.has_key? 'id'
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
