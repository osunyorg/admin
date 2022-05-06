class Communication::Block::Template::Page < Communication::Block::Template
  def build_git_dependencies
    add_dependency selected_pages
    selected_pages.each do |page|
      add_dependency page.active_storage_blobs
    end
  end

  def selected_pages
    @selected_pages ||= free_pages
  end

  def main_page
    @main_page ||= page(data['page_id'])
  end

  def show_description
    data['show_description'] || false
  end

  def show_image
    data['show_image'] || false
  end

  protected

  def free_pages
    elements.map { |element|
                  p = page(element['id'])
                  next if p.nil?
                  {
                    page: p,
                    show_description: element['show_description'] || false,
                    show_image: element['show_image'] || false
                  }.to_dot
                }
                .compact
  end

  def page(id)
    return if id.blank?
    page = block.about&.website
                       .pages
                       .published
                       .find_by(id: id)
  end
end
