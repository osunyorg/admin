class Communication::Block::Post < Communication::Block::Abstract
  def build_git_dependencies
    add_dependency category unless category.nil?
    add_dependency posts
    posts.each do |post|
      add_dependency post.active_storage_blobs
      add_dependency post.active_storage_blobs
      if post.author.present?
        add_dependency [author, author.author]
        add_dependency author.active_storage_blobs
      end
    end
  end

  def category
    @category ||= block.about&.website.categories.find_by(id: block.data['category_id'])
  end

  def posts
    @posts ||= category.nil? ? free_posts : category_posts
  end

  protected

  def category_posts
    quantity = block.data['posts_quantity'] || 3
    category.posts.ordered.limit(quantity)
  end

  def free_posts
    @posts = []
    elements.each do |element|
      id = element['id']
      next if id.blank?
      post = block.about&.website.posts.find_by id: id
      next if post.nil?
      @posts << post
    end
    @posts
  end
end
