class Communication::Block::Template::Post < Communication::Block::Template::Base
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
    # kind could be: selection, category, or all
    @selected_posts ||= send "selected_posts_#{kind}"
  end

  protected

  def kind
    @kind ||= data['kind'] || 'all'
  end

  def selected_posts_all
    quantity = data['posts_quantity'] || 3
    block.about&.website
                .posts
                .published
                .ordered
                .limit(quantity)
  end

  def selected_posts_category
    quantity = data['posts_quantity'] || 3
    category_ids = [category.id, category.descendants.map(&:id)].flatten
    university.communication_website_posts.joins(:categories)
                                          .where(categories: { id: category_ids })
                                          .distinct
                                          .published
                                          .ordered
                                          .limit(quantity)
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
