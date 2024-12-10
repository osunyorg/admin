class Communication::Block::Component::Program < Communication::Block::Component::BaseReference

  def program
    template.block.university.programs.find_by(id: data)
  end

  def dependencies
    [program]
  end

end
