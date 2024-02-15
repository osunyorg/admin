class Static::Text < Static::Default

  # Pour info (pas utilisé)
  # https://til.codes/escaping-special-characters-like-in-rails-html-views/
  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared = strip_tags @prepared
      @prepared = CGI.unescapeHTML @prepared
      @prepared = @prepared.ortho(locale: locale)
      @prepared = indent @prepared
      @prepared = raw @prepared
    end
    @prepared
  end

end