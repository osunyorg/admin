class Communication::Block::Template::Title < Communication::Block::Template::Base

  has_layouts [:classic, :collapsed]

  def empty?
    block.title.blank?
  end

end
