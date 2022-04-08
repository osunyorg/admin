class Communication::Block::Template::Gallery < Communication::Block::Template
  def build_git_dependencies
    add_dependency images
  end

  def images_with_alt
    unless @images_with_alt
      @images_with_alt = []
      elements.each do |element|
        blob = find_blob element, 'file'
        next if blob.nil?
        @images_with_alt << {
          blob: blob,
          alt: element['alt']
        }.to_dot
      end
    end
    @images_with_alt
  end

  protected

  def images
    @images ||= images_with_alt.map { |hash| hash.blob }
  end
end
