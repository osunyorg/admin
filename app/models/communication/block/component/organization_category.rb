class Communication::Block::Component::OrganizationCategory < Communication::Block::Component::Base

  def data=(value)
    super(value)
    # Calling translate! will make sure that the category's language matches the block's language.
    translate!
  end

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
    return unless category.present? && category.language_id != template.language.id
    @data = category.find_or_translate!(template.language).id
  end

end
