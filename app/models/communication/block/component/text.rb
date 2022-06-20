class Communication::Block::Component::Text < Communication::Block::Component::Base

  def data=(value)
    @data = Osuny::Sanitizer.sanitize value, 'string'
  end

end
