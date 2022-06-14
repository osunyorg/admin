class Communication::Block::Template::File < Communication::Block::Template::Base

  def build_git_dependencies
    files.each do |file|
      add_dependency file.blob
    end
  end

  def files
    @files ||= elements.map { |element|
        file(element)
      }.compact
  end

  protected

  def file(element)
    {
      title: element['title'],
      blob: find_blob(element, 'file')
    }.to_dot
  end

end
