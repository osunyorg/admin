class Static::Html < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      # Sanitize before clean_code, otherwise we remove the spans!
      @prepared = sanitize @prepared
      @prepared = remove_line_breaks @prepared
      @prepared = clean_code @prepared
      @prepared = remove_useless_br @prepared
      # clean_empty_paragraphs_at_beginning_and_end re-sends \n, because of Nokogiri.
      # Can be changed with a weird hack (Nokogiri(format: 0)) but a gsub is easiest (PAB)
      @prepared = remove_line_breaks @prepared
    end
    @prepared
  end

  private

  def remove_line_breaks(html)
    clean = html.gsub "\r", ''
    # if no whitespace in the next line html in static won't be on one line
    clean = clean.gsub "\n", ' '
    clean
  end

  def clean_code(html)
    return html unless html.present?
    @doc = Nokogiri::HTML::DocumentFragment.parse(html)
    clean_empty_paragraphs_at_beginning_and_end!
    clean_external_links!
    @doc.to_html
  end

  # based on https://stackoverflow.com/questions/17479135/how-do-i-trim-the-head-and-tail-of-empty-tags-in-html
  # and https://stackoverflow.com/questions/16417292/how-do-i-remove-white-space-between-html-nodes
  def clean_empty_paragraphs_at_beginning_and_end!
    while(@doc.children.any? && 
          @doc.children.first.name == 'p' && 
          @doc.children.first.text.strip == '')
      @doc.children.first.remove
    end
    while(@doc.children.any? && 
          @doc.children.last.name == 'p' && 
          @doc.children.last.text.strip == '')
      @doc.children.last.remove
    end
  end

  # Each external link needs a <span class="sr-only">(lien externe)</span> in it
  # https://github.com/osunyorg/admin/issues/2151
  # It also needs rel="noreferrer"
  # https://github.com/osunyorg/theme/issues/667 
  def clean_external_links!
    hint = I18n.t('html.external_link', locale: locale)
    span = " <span class=\"sr-only\">(#{hint})</span>"
    @doc.css('a[target=_blank]').each do |link|
      # Add text for screen readers
      link << span
      # Add noreferrer
      # https://nokogiri.org/rdoc/Nokogiri/XML/Node.html#method-i-kwattr_add
      link.kwattr_add('rel', 'noreferrer')
    end
  end

  # Suppression des <br></p>
  # https://github.com/osunyorg/admin/issues/2462
  def remove_useless_br(html)
    html.gsub('<br></p>', '</p>')
  end

end