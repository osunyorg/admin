class Communication::Block::Component::Person < Communication::Block::Component::Base

  def person
    template.block.university.people.find_by(id: data)
  end

  def git_dependencies
    [person, person&.picture&.blob]
  end

end
