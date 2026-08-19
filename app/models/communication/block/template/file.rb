class Communication::Block::Template::File < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  # Permet de gérer les contextes
  def communication_files
    elements.map(&:communication_file).compact_blank
  end

  def dom_count
    5 +
    elements.length * 10
  end
end
