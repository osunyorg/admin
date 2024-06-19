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
  has_component :option_summary,      :boolean, default: false

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

  def selected_projects_all
    block.about&.website
                .projects
                .for_language(block.language)
                .published
                .ordered
                .limit(projects_quantity)
  end

  def selected_projects_category
    return [] if category.nil?
    category_ids = [category.id, category.descendants.map(&:id)].flatten
    university.communication_website_projects.for_language(block.language)
                                            .joins(:categories)
                                            .where(categories: { id: category_ids })
                                            .distinct
                                            .published
                                            .ordered
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
    block.about&.website
                .projects
                .for_language(block.language)
                .published
                .find_by(id: id)
  end

end