class Communication::Block::Template::Page < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :mode, :option, options: [
    :selection,
    :children,
    :category
  ]
  has_component :text, :rich_text
  has_component :page_id, :page
  has_component :category_id, :page_category
  has_component :pages_quantity, :number, options: 3

  has_component :option_image,        :boolean, default: true
  has_component :option_main_summary, :boolean, default: true
  has_component :option_summary,      :boolean, default: true

  def page
    page_id_component.page
  end

  def category
    category_id_component.category
  end

  def dependencies
    selected_pages
  end

  def selected_pages
    @selected_pages ||= send "selected_pages_#{mode}"
  end

  def allowed_for_about?
    !website.nil?
  end

  def children
    selected_pages
  end

  protected

  def selected_pages_selection
    elements.map { |element| element.page }.compact
  end

  def selected_pages_children
    return [] unless page
    page.children
        .published_now_in(block.language)
        .ordered
  end

  def selected_pages_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten

    block.about&.website
                .pages
                .published_now_in(block.language)
                .for_category(category_ids)
                .ordered(block.language)
                .limit(pages_quantity)
  end

end
