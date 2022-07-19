class Communication::Block::Component::TimeSlot < Communication::Block::Component::Base

  def default_data
    {
      'from' => nil,
      'to' => nil
    }
  end

end
