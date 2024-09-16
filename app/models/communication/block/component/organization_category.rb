class Communication::Block::Component::OrganizationCategory < Communication::Block::Component::Base

  def categories
    university.organization_categories
              .tmp_original # TODO L10N : To remove
  end

  def category
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
