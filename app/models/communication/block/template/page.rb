class Communication::Block::Template::Page < Communication::Block::Template
  def build_git_dependencies
    add_dependency main_page
    selected_pages.each do |page|
      add_dependency page
      add_dependency page.active_storage_blobs
    end
  end

  def selected_pages
    # kind could be: selection (default), children
    @selected_pages ||= send "selected_pages_#{kind}"
  end

  def main_page
    @main_page ||= page(data['page_id'])
  end

  def layout
    data['layout'] || 'grid'
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

  def kind
    @kind ||= data['kind'] || 'selection'
  end

  def selected_pages_selection
    elements.map { |element|
      page element['id']
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
