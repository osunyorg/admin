class Communication::Block::Component::Code < Communication::Block::Component::Base

    def data=(value)
      @data = Osuny::Sanitizer.sanitize value, 'text'
    end
  
  end
  