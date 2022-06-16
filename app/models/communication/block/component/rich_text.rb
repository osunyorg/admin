class Communication::Block::Component::RichText < Communication::Block::Component::Base

  def data=(value)
    @data = clean(value)
  end

  protected

  def clean(value)
    value = SummernoteCleaner.clean value.to_s
    value = ActionView::Base.full_sanitizer.sanitize value
    value
  end
end
