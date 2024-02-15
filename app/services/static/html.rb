class Static::Html < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.strip.dup
      @prepared = @prepared.ortho(locale: locale)
      @prepared = sanitize @prepared
      @prepared.gsub! "\r", ''
      @prepared.gsub! "\n", ' '
      @prepared.gsub! "/rails/active_storage", "#{@university.url}/rails/active_storage"      
      @prepared = sanitize @prepared
    end
    @prepared
  end

end