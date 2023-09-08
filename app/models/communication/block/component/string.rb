class Communication::Block::Component::String < Communication::Block::Component::Base

  def data=(value)
    @data = Osuny::Sanitizer.sanitize value, 'string'
  end

  def full_text
    data
  end

end
