class Communication::Block::Template::Post < Communication::Block::Template
  def build_git_dependencies
    add_dependency category unless category.nil?
    selected_posts.each do |post|
      add_dependency post
      add_dependency post.active_storage_blobs
      if post.author.present?
        add_dependency post.author
        add_dependency post.author.author
        add_dependency post.author.active_storage_blobs
      end
    end
  end

  def category
    @category ||= block.about&.website.categories.find_by(id: block.data['category_id'])
  end

  def selected_posts
    @selected_posts ||= category.nil? ? free_posts : category_posts
  end

  protected

  def category_posts
    quantity = block.data['posts_quantity'] || 3
    category.posts.ordered.limit(quantity)
  end

  def free_posts
    array = []
    elements.map do |element|
      id = element['id']
      next if id.blank?
      post = block.about&.website.posts.find_by id: id
      next if post.nil?
      array << post
    end
    array
  end
end
