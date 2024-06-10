class Static::Default
  include ActionView::Helpers

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

  # Obsolete
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

  def turn_linebreak_to_br(text)
    # Order matters!
    # First, replace the 2 signs
    text.gsub! "\r\n", "\n"
    # The, the isolated \r (if you do it first you get \n\n)
    text.gsub! "\r", "\n"
    # Then the \n are turned
    text.gsub! "\n", "<br>"
    text
  end

end
