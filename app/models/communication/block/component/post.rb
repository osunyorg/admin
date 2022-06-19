class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts.published.find_by(id: data)
  end

  def git_dependencies
    [
      post,
      post&.author,
      post&.author&.author,
      post&.author&.picture&.blob
    ]
  end

end
