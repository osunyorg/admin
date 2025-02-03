class Communication::Block::Component::Taxonomy < Communication::Block::Component::Base

  def taxonomy
    return unless website
    template.current_categories
            .find_by(id: data)
  end

  def dependencies
    [taxonomy]
  end

end
