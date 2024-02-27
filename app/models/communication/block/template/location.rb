class Communication::Block::Template::Location < Communication::Block::Template::Base

  has_elements

  def dependencies
    selected_locations
  end

  def selected_locations
    @selected_locations ||= elements.map { |element| element.location }.compact
  end

  def allowed_for_about?
    website.present? && available_locations.any?
  end

  def available_locations
    website.administration_locations
  end
end
