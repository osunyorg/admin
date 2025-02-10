class Communication::Block::Template::Testimonial < Communication::Block::Template::Base

  has_elements

  def allowed_for_about?
    !about.respond_to?(:extranet)
  end
  
  def top_screen_reader_only
    true
  end
end
