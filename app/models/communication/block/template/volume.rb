class Communication::Block::Template::Volume < Communication::Block::Template::Base

  has_elements
  has_component :mode, :option, options: [
    :all,
    :selection
  ]
  has_component :quantity, :number, default: 3

  def dependencies
    selected_volumes
  end

  def selected_volumes
    @selected_volumes ||= send "selected_volumes_#{mode}"
  end

  def allowed_for_about?
    website.present? && website.research_volumes.any?
  end

  def children
    selected_volumes
  end

  protected

  def selected_volumes_all
    available_volumes.ordered(block.language).limit(quantity)
  end

  def selected_volumes_selection
    elements.map { |element|
      volume(element.id)
    }.compact
  end

  def volume(id)
    return if id.blank?
    available_volumes.find_by(id: id)
  end

  def available_volumes
    website.research_volumes
  end
end
