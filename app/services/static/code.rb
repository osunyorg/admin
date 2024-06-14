class Static::Code < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.dup
      @prepared = lazy_load_iframes @prepared
      @prepared = remove_linebreak @prepared
      @prepared = raw @prepared
    end
    @prepared
  end

  protected

  def lazy_load_iframes(text)
    doc = Nokogiri::HTML::DocumentFragment.parse(text)
    doc.css('iframe').each do |iframe|
      iframe['loading'] = 'lazy'
    end
    doc.to_html
  end

end