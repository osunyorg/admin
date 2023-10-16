class Static::Text < Static::Default

  def prepared
    byebug if @about.nil?
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared = @prepared.ortho(locale: ortho_locale)
      @prepared = ActionController::Base.helpers.strip_tags @prepared
      @prepared = CGI.unescapeHTML @prepared
      @prepared = indent @prepared
    end
    @prepared
  end

end