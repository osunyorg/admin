class Communication::Block::Template::Post < Communication::Block::Template
  def build_git_dependencies
    add_dependency category unless category.nil?
    add_dependency selected_posts
    selected_posts.each do |post|
      add_dependency post.active_storage_blobs
      if post.author.present?
        add_dependency [post.author, post.author.author]
        add_dependency post.author.active_storage_blobs
      end
    end
  end

  def category
    @category ||= block.about&.website.categories.find_by(id: data['category_id'])
  end

  def selected_posts
    @selected_posts ||= category.nil? ? free_posts : category_posts
  end

  protected

  def category_posts
    quantity = data['posts_quantity'] || 3
    category.posts.ordered.limit(quantity)
  end

  def free_posts
    array = []
    elements.map do |element|
      array << post(element['id'])
    end
    array.compact!
    array
  end

  def post(id)
    return if id.blank?
    block.about&.website.posts.find_by id: id
  end
end
