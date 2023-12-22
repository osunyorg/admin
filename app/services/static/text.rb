class Static::Text < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared = strip_tags @prepared
      @prepared = CGI.unescapeHTML @prepared
      @prepared = @prepared.ortho(locale: locale)
      @prepared = indent @prepared
    end
    @prepared
  end

end