class Communication::Block::Component::Image < Communication::Block::Component::Base
  def data
    @data['blob'] = template.blob_with_id @data['id'] if @data&.has_key? 'id'
    @data
  end
end
