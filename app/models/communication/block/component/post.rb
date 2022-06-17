class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return if data.blank?
    block.about&.website
                .posts
                .published
                .find_by(id: data)
  end

end
