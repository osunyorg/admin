class Communication::Block::Template::Timeline < Communication::Block::Template::Base

  has_elements
  has_layouts [:vertical, :horizontal]

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end

  def children
    elements
  end
end
