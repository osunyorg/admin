class Communication::Block::Template::File < Communication::Block::Template
  def build_git_dependencies
    add_dependency active_storage_blobs
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
