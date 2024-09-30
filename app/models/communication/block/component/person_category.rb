class Communication::Block::Component::PersonCategory < Communication::Block::Component::Base

  def categories
    university.person_categories
  end

  def category
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
