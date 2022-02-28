class Communication::Block::Testimonial < Communication::Block::Abstract
  def build_git_dependencies
    elements.each do |testimonial|
      blob = find_blob testimonial, 'photo'
      add_dependency blob unless blob.nil?
    end
  end
end
