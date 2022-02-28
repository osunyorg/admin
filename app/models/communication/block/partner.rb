class Communication::Block::Partner < Communication::Block::Abstract
  def build_git_dependencies
    elements.each do |partner|
      blob = find_blob partner, 'logo'
      add_dependency blob unless blob.nil?
    end
  end
end
