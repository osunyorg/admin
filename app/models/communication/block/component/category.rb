class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    return unless website
    website.categories.find_by(id: data)
  end

  def display_dependencies
    [category]
  end

  def translate!
    return unless category.present?
    @data = category.find_or_translate!(template.language).id
  end

end
