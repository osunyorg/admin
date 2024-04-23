class Communication::Block::Component::OrganizationCategory < Communication::Block::Component::Base

  def categories
    university.organization_categories
  end

  def category
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

  def translate!
    return unless category.present?
    @data = category.find_or_translate!(template.language).id
  end

end
