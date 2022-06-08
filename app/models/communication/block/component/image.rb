class Communication::Block::Component::Image < Communication::Block::Component::Base

  # def data
  #   # Loading the blob when needed, not saved in the database
  #   @data['blob'] = template.blob_with_id @data['id'] if @data&.has_key? 'id'
  #   @data
  # end

  def blob
    @blob ||= template.blob_with_id data['id']
  end

end
