# Used by the Category template
class Communication::Block::Component::Taxonomy < Communication::Block::Component::Base

  def taxonomy
    return unless website
    template.categories_for_current_kind
            .find_by(id: data)
  end

  def dependencies
    [taxonomy]
  end

end
