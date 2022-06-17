class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts.published.find_by(id: data)
  end

  def git_dependencies
    active_storage_blobs +
    [post, post.author, post.author.author]
  end

  def active_storage_blobs
    post&.author&.active_storage_blobs || []
  end

end
