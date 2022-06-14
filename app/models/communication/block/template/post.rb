class Communication::Block::Template::Post < Communication::Block::Template::Base

  has_component :mode, :option, options: [:all, :category, :selection]
  has_component :posts_quantity, :number, options: 3

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
    @category ||= block.about&.website
                              .categories
                              .find_by(id: data['category_id'])
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
      post(element['id'])
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
