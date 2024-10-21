class Communication::Block::Template::Post < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :highlight,
    :alternate,
    :large,
    :carousel
  ]
  has_component :mode, :option, options: [
    :all,
    :category,
    :selection,
    :categories
  ]
  has_component :posts_quantity, :number, options: 3
  has_component :category_id, :post_category

  has_component :option_author,       :boolean, default: false
  has_component :option_categories,   :boolean, default: false
  has_component :option_date,         :boolean, default: false
  has_component :option_image,        :boolean, default: true
  has_component :option_reading_time, :boolean, default: false
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_summary,      :boolean, default: true

  def category
    category_id_component.category
  end

  def dependencies
    selected_posts
  end

  def selected_posts
    @selected_posts ||= send "selected_posts_#{mode}"
  end

  def allowed_for_about?
    !website.nil?
  end

  def children
    selected_posts
  end

  protected

  def base_posts
    block.about&.website
                .posts
                .published_now_in(block.language)
  end

  def selected_posts_all
    base_posts.ordered(block.language)
              .limit(posts_quantity)
  end

  def selected_posts_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten

    base_posts.for_category(category_ids)
              .ordered(block.language)
              .limit(posts_quantity)
  end

  def selected_posts_selection
    elements.map { |element|
      post(element.id)
    }.compact
  end

  def selected_posts_categories
    []
  end

  def post(id)
    return if id.blank?
    base_posts.find_by(id: id)
  end
end
