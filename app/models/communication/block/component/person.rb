class Communication::Block::Component::Person < Communication::Block::Component::Base

  def data=(value)
    super(value)
    # Calling translate! will make sure that the person's language matches the block's language.
    translate!
  end

  def person
    template.block
            .university
            .people
            .find_by(id: data)
  end

  def dependencies
    [person]
  end

  def translate!
    return unless person.present? && person.language_id != template.language.id
    @data = person.find_or_translate!(template.language).id
  end

end
