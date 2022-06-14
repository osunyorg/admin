class Communication::Block::Template::Testimonial::Testimonial < Communication::Block::Template::Base

  has_component :text, :text
  has_component :author, :string
  has_component :job, :string
  has_component :photo, :image

end
