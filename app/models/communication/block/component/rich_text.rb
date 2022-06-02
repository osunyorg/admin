class Communication::Block::Component::RichText < Communication::Block::Component::Base
  def data=(value)
    @data = Osuny::Sanitizer.sanitize value, 'text'
  end
end
