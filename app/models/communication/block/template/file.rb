class Communication::Block::Template::File < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  def communication_files
    @communication_files ||= elements.map(&:communication_file).compact
  end
end
