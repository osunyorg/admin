class Communication::Block::Component::Organization < Communication::Block::Component::Base

  def data=(value)
    super(value)
    # Calling translate! will make sure that the organization's language matches the block's language.
    translate!
  end

  def organization
    template.block
            .university
            .organizations
            .find_by(id: data)
  end

  def dependencies
    [organization]
  end

  def translate!
    return unless organization.present? && organization.language_id != template.language.id
    @data = organization.find_or_translate!(template.language).id
  end

end
