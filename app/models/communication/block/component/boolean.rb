class Communication::Block::Component::Boolean < Communication::Block::Component::Base

  def default_data
    @default.nil? ? false 
                  : @default
  end

  def data
    @data.nil?  ? default_data
                : @data
  end

  def data=(value)
    @data = [true, 1, "true", "TRUE", "1"].include?(value)
  end

end
