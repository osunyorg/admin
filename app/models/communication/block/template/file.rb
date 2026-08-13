class Communication::Block::Template::File < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  def communication_files
    selected_files
  end

  def selected_files
    @selected_files ||= elements.map(&:communication_file).compact
  end

  def dom_count
    5 +
    elements.length * 10
  end
end
