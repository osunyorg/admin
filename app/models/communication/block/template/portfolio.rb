class Communication::Block::Template::Portfolio < Communication::Block::Template::Base

  has_layouts [
    :grid,
    :list,
    :alternate,
    :large
  ]

  has_component :projects_quantity, :number, options: 3

  def dependencies
    selected_projects
  end

  def selected_projects
    @selected_projects ||= selected_projects_all
  end

  def allowed_for_about?
    website.present? && website.projects.any?
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

  def selected_projects_selection
    elements.map { |element|
      element.projet
    }.compact
  end

end