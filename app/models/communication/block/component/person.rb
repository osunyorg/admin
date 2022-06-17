class Communication::Block::Component::Person < Communication::Block::Component::Base

  def person
    template.block.university.people.find_by(id: data)
  end

end
