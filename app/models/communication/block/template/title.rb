class Communication::Block::Template::Title < Communication::Block::Template::Base

  has_layouts [:classic, :collapsed]

  def empty?
    block.title.blank?
  end

  def dom_count
    count = 2
    # TODO collapsed
    count += 2 if block.about.show_toc?
    count
  end
end
