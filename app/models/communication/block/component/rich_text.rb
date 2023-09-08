class Communication::Block::Component::RichText < Communication::Block::Component::Base

  def data=(value)
    value = SummernoteCleaner.clean value.to_s
    value = Osuny::Sanitizer.sanitize value, 'text'
    @data = value
  end

  def full_text
    ActionController::Base.helpers.strip_tags data
  end

end
