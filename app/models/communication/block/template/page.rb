class Communication::Block::Template::Page < Communication::Block::Template::Base

  has_layouts [:grid, :list, :cards]
  has_elements Communication::Block::Template::Page::Element
  has_component :mode, :option, options: [:selection, :children]
  has_component :text, :rich_text

  def selected_pages
    @selected_pages ||= send "selected_pages_#{mode}"
  end

  def main_page
    @main_page ||= page(data['page_id'])
  end

  def show_main_description
    data['show_main_description'] || false
  end

  def show_description
    data['show_description'] || false
  end

  def show_image
    data['show_image'] || false
  end

  protected

  def selected_pages_selection
    return []
    elements.map { |element|
      element.page
    }.compact
  end

  def selected_pages_children
    return [] unless main_page
    main_page.children
             .published
             .ordered
  end

  def page(id)
    return if id.blank?
    page = block.about&.website
                       .pages
                       .published
                       .find_by(id: id)
  end
end
