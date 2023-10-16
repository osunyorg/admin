class Static::Code < Static::Default

  def prepared
    unless @prepared
      @prepared = @text.to_s.dup
      @prepared = indent @prepared
      @prepared = ActionController::Base.helpers.raw @prepared
    end
    @prepared
  end

end