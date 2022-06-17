class Communication::Block::Template::Post < Communication::Block::Template::Base

  has_elements
  has_component :mode, :option, options: [:all, :category, :selection]
  has_component :posts_quantity, :number, options: 3
  has_component :category_id, :category

  def add_custom_git_dependencies
    selected_posts.each do |post|
      add_dependency post
      add_dependency post.active_storage_blobs
      if post.author.present?
        add_dependency [post.author, post.author.author]
        add_dependency post.author.active_storage_blobs
      end
    end
  end

  def category
    category_id_component.category
  end

  def selected_posts
    @selected_posts ||= send "selected_posts_#{mode}"
  end

  protected

  def selected_posts_all
    block.about&.website
                .posts
                .published
                .ordered
                .limit(posts_quantity)
  end

  def selected_posts_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten
    university.communication_website_posts.joins(:categories)
                                          .where(categories: { id: category_ids })
                                          .distinct
                                          .published
                                          .ordered
                                          .limit(posts_quantity)
  end

  def selected_posts_selection
    elements.map { |element|
      post(element.id)
    }.compact
  end

  def post(id)
    return if id.blank?
    block.about&.website
                .posts
                .published
                .find_by(id: id)
  end
end
