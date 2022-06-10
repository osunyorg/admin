class Communication::Block::Template::Testimonial::Testimonial < Communication::Block::Template::Base

  has_text :text
  has_string :author
  has_string :job
  has_image :photo

end
