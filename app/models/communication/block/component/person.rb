class Communication::Block::Component::Person < Communication::Block::Component::Base

  def person
    template.block.university.people.find_by(id: data)
  end

  def dependencies
    [person]
  end

  def translate!
    return unless data.present?
    @data = person.find_or_translate!(template.language).id
  end

end
