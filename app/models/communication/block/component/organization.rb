class Communication::Block::Component::Organization < Communication::Block::Component::Base

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
    return unless organization.present?
    @data = organization.find_or_translate!(template.language).id
  end

end
