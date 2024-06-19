class Communication::Block::Template::Program < Communication::Block::Template::Base

  has_elements
  has_layouts [:list, :grid]

  has_component :option_diploma,      :boolean, default: true
  has_component :option_image,        :boolean, default: false
  has_component :option_summary,      :boolean, default: false

  def dependencies
    selected_programs
  end

  def selected_programs
    @selected_programs ||= elements.map { |element| element.program }.compact
  end

  def allowed_for_about?
    website.present? && website.education_programs.any?
  end

  def available_programs
    website.education_programs
  end
  
  def children
    selected_programs
  end
end
