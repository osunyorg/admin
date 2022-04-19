class Communication::Block::Template::Page < Communication::Block::Template
  def build_git_dependencies
    # add_dependency category unless category.nil?
    # add_dependency selected_posts
    # selected_posts.each do |post|
    #   add_dependency post.active_storage_blobs
    #   if post.author.present?category.nil? ? free_posts : category_posts
    #     add_dependency [post.author, post.author.author]
    #     add_dependency post.author.active_storage_blobs
    #   end
    # end
  end

  # def category
  #   @category ||= block.about&.website.categories.find_by(id: data['category_id'])
  # end

  def selected_pages
    @selected_pages ||= free_pages
  end

  def main_page
    @main_page ||= page(data['page_id'])
  end

  def show_description
    data['show_description'] || false
  end

  protected

  def free_pages
    elements.map { |element| 
                  {
                    slug: page_slug(element['id']),
                    show_description: element['show_description'] || false,
                    show_image: element['show_image'] || false
                  }.to_dot
                }
                .compact
  end

  def page(id)
    return if id.blank?
    page = block.about&.website.pages.find_by id: id
  end

  def page_slug(id)
    page = page(id)
    return if page.blank?
    return page.slug
  end
end
