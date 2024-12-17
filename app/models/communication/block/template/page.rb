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
  has_component :text, :rich_text # Deprecated
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

  def top_title
    page_l10n.present? ? page_l10n.to_s : block.title
  end

  def top_description
    page_l10n.present? ? page_l10n.summary : false
  end

  protected

  def page_l10n
    return nil if page.nil?
    l10n = page.localization_for(language)
    return nil if l10n.draft?
    l10n
  end

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
