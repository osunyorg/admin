class Communication::Block::Template::Gallery < Communication::Block::Template
  def build_git_dependencies
    add_dependency images
  end

  def images_with_alt
    unless @images_with_alt
      @images_with_alt = []
      elements.each do |element|
        image = find_blob element, 'file'
        next if image.nil?
        @images_with_alt << {
          image: image,
          alt: element['alt']
        }
      end
    end
    @images_with_alt
  end

  def images
    @images ||= images_with_alt.map { |hash| hash[:image] }
  end
end
