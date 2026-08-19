class Communication::Block::Template::Gallery < Communication::Block::Template::Base

  has_elements
  has_layouts [:grid, :carousel, :large]
  has_component :description, :rich_text

  def empty?
    communication_medias.none?
  end

  # Permet de gérer les contextes
  def communication_medias
    elements.map(&:communication_media).compact_blank
  end
end
