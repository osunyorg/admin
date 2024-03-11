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
    @selected_projects ||= elements.map { |element| element.projet }.compact
  end

  def allowed_for_about?
    website.present? && website.projects.any?
  end

end