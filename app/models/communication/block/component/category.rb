# Not used yet, will be used by the Category Template to select specific categories
class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    return unless website
    template.categories_for_current_kind
            .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
