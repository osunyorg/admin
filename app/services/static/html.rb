class Static::Html < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared.gsub! "\r", ''
      # if no whitespace in the next line html in static won't be on one line
      @prepared.gsub! "\n", ' '
      @prepared = clean_empty_paragraphs_at_beginning_and_end @prepared
      @prepared = @prepared.ortho(locale: locale)
      # TODO ça ne doit plus être utile depuis un siècle
      @prepared.gsub! "/rails/active_storage", "#{@university.url}/rails/active_storage"      
      @prepared.gsub! "\n", ''
      @prepared = sanitize @prepared
    end
    @prepared
  end

  private

  # based on https://stackoverflow.com/questions/17479135/how-do-i-trim-the-head-and-tail-of-empty-tags-in-html
  # and https://stackoverflow.com/questions/16417292/how-do-i-remove-white-space-between-html-nodes
  def clean_empty_paragraphs_at_beginning_and_end(text)
    return text unless text.present?

    doc = Nokogiri::HTML::DocumentFragment.parse(text)

    while(doc.children.any? && doc.children.first.name == 'p' && doc.children.first.text.strip == '')
      doc.children.first.remove
    end

    while(doc.children.any? && doc.children.last.name == 'p' && doc.children.last.text.strip == '')
      doc.children.last.remove
    end

    doc.to_html
  end

end