class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    return unless template.block.about&.website
    template.block
            .about
            .website
            .categories
            .find_by(id: data)
  end

end
