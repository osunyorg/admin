class Communication::Block::Template::Link < Communication::Block::Template::Base

  has_elements
  has_component :description, :rich_text

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end
  
end