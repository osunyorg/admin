class Communication::Block::Template::Project < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :grid,
    :list,
    :alternate,
    :large
  ]
  has_component :mode, :option, options: [
    :all,
    :category,
    :selection,
    :categories
  ]
  has_component :projects_quantity, :number, options: 3
  has_component :category_id, :project_category

  has_component :option_categories,   :boolean, default: true
  has_component :option_image,        :boolean, default: true
  has_component :option_subtitle,     :boolean, default: true
  has_component :option_summary,      :boolean, default: false
  has_component :option_year,         :boolean, default: true

  def category
    category_id_component.category
  end

  def dependencies
    selected_projects
  end

  def selected_projects
    @selected_projects ||= send "selected_projects_#{mode}"
  end

  def allowed_for_about?
    website.present? && website.projects.any?
  end

  def children
    selected_projects
  end

  protected

  def base_projects
    block.about&.website
                .projects
                .published_now_in(block.language)
  end

  def selected_projects_all
    base_projects.ordered(block.language)
                 .limit(projects_quantity)
  end

  def selected_projects_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten

    base_projects.for_category(category_ids)
                 .ordered(block.language)
                 .limit(projects_quantity)
  end

  def selected_projects_selection
    elements.map { |element|
      project(element.id)
    }.compact
  end

  def selected_projects_categories
    []
  end

  def project(id)
    return if id.blank?
    base_projects.find_by(id: id)
  end

end