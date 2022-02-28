class Communication::Block::Gallery < Communication::Block::Abstract
  def build_git_dependencies
    dependencies = []
    elements.each do |image|
      blob = find_blob image, 'file'
      add_dependency blob unless blob.nil?
    end
    dependencies.uniq
  end
end
