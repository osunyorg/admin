class Communication::Block::Component::TimeSlot < Communication::Block::Component::Base

  def from
    data['from']
  end
  
  def to
    data['to']
  end

  def present?
    from && from != '0' && to && to != '0' 
  end

  def blank?
    !present?
  end

  def default_data
    {
      'from' => '',
      'to' => ''
    }
  end

end
