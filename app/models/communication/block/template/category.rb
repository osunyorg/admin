class Communication::Block::Template::Category < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :cards,
    :alternate,
    :large
  ]
  has_component :category_kind, :option, options: (
    Communication::Block::CATEGORIES[:references] - [
      :categories,
      :locations,
      :papers,
      :volumes,
    ]
  )
  has_component :taxonomy_id, :taxonomy
  has_component :description, :rich_text

  has_component :option_count,        :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_summary,      :boolean, default: true

  def category_kinds_allowed
    @category_kinds_allowed = []
    category_kind_component.options.each do |kind|
      b = Communication::Block.new
      b.template_kind = kind
      b.about = about
      next unless b.template.allowed_for_about?
      @category_kinds_allowed << kind
    end
    @category_kinds_allowed
  end

  def categories_for(category_kind)
    case category_kind.to_sym
    when :agenda
      website&.agenda_categories
    when :locations
      # No category yet
    when :organizations
      university.organization_categories
    when :papers
      # No category yet
    when :pages
      website&.page_categories
    when :persons
      university.person_categories
    when :posts
      website&.post_categories
    when :programs
      university.education_program_categories
    when :projects
      website&.portfolio_categories
    when :volumes
      # No category yet
    end
  end

  def selected_categories
    current_categories.reject { |category| category.count_objects_in(block.language, website).zero? }
  end

  def current_categories
    categories_for(category_kind)
  end

  def taxonomy
    taxonomy_id_component.taxonomy
  end
end