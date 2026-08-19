class Communication::Block::Template::Link < Communication::Block::Template::Base

  has_elements
  has_layouts [
    :cards,
    :grid,
    :list
  ]
  has_component :description, :rich_text

  has_component :option_icons, :boolean, default: false

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end
  
  # Permet de gérer les contextes
  def communication_medias
    elements.map(&:communication_media).compact_blank
  end

end