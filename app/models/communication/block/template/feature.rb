class Communication::Block::Template::Feature < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  has_component :option_icons, :boolean, default: false

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end

  def children
    elements
  end
end
