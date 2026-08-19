class Communication::Block::Template::KeyFigure < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end
  
  # Permet de gérer les contextes
  def communication_medias
    elements.map(&:communication_media).compact_blank
  end

end
