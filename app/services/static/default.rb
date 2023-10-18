class Static::Default

  def initialize(text, depth: 1, about: nil, university: nil)
    @text = text
    @depth = depth
    @about = about
    @university = university
  end

  def prepared
    raise NotImplementedError
  end

  protected

  def locale
    return if @about.nil?
    return unless @about.respond_to?(:language)
    @about.language&.iso_code
  end

  def indent(text)
    indentation = '  ' * @depth
    # Remove useless \r
    text.gsub! "\r\n", "\n"
    # Replace lonely \r
    text.gsub! "\r", "\n"
    # Indent properly to avoid broken frontmatter, with 2 lines so the linebreak work
    text.gsub! "\n", "\n#{indentation}\n#{indentation}"
    text.chomp!
    text
  end

end
