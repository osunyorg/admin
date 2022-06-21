class Communication::Block::Component::Array < Communication::Block::Component::Base

  def data=(value)
    # Nil values must be turned to ""
    @data = value.map { |s| s.to_s }
  end

  def default_data
    ['']
  end

end
