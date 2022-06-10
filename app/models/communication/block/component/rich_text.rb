class Communication::Block::Component::RichText < Communication::Block::Component::Base

  def data=(value)
    @data = SummernoteCleaner.clean value.to_s
  end

end
