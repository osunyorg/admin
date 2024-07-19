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

end
