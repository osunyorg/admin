class Communication::Block::Template::Page < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :list, :cards]
  has_component :mode, :option, options: [:selection, :children]
  has_component :text, :rich_text
  has_component :page_id, :page
  has_component :show_main_description, :boolean
  has_component :show_description, :boolean
  has_component :show_image, :boolean

  def page
    page_id_component.page
  end

  def selected_pages
    @selected_pages ||= send "selected_pages_#{mode}"
  end

  protected

  def selected_pages_selection
    elements.map { |element| element.page }.compact
  end

  def selected_pages_children
    return [] unless main_page
    main_page.children.published.ordered
  end

end
