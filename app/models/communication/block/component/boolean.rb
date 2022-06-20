class Communication::Block::Component::Boolean < Communication::Block::Component::Base

  def default_data
    false
  end

  def data=(value)
    @data = [true, 1, "true", "TRUE", "1"].include?(value)
  end

end
