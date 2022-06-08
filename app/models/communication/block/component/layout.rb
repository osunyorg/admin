class Communication::Block::Component::Layout < Communication::Block::Component::Base

  def default_data
    "#{template.default_layout}"
  end

  def data=(value)
    @data = value.blank?  ? template.default_layout
                          : value
  end

end
