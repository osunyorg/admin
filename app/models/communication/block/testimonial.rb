class Communication::Block::Testimonial < Communication::Block::Abstract
  def git_dependencies
    dependencies = []
    elements.each do |testimonial|
      blob = find_blob testimonial, 'photo'
      next if blob.nil?
      dependencies += [blob]
    end
    dependencies.uniq
  end
end
