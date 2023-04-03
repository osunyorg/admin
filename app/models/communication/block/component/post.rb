class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts.published.find_by(id: data)
  end

  def dependencies
    [post]
  end

  def translate!
    return unless website && data.present?
    source_post = website.posts.find_by(id: data)
    @data = source_post.find_or_translate!(template.language).id if source_post.present?
  end

end
