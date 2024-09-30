class Communication::Block::Template::Page < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :mode, :option, options: [:selection, :children]
  has_component :text, :rich_text
  has_component :page_id, :page

  has_component :option_image,        :boolean, default: true
  has_component :option_main_summary, :boolean, default: true
  has_component :option_summary,      :boolean, default: true

  def page
    page_id_component.page
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

  def heading_title
    block.title.present?  ? block.title
                          : page&.to_s_in(block.language)
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

end
