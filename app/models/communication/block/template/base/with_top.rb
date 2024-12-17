module Communication::Block::Template::Base::WithTop
  extend ActiveSupport::Concern

  def top_title
    block.try(:title)
  end

  def top_heading
    block.heading_rank_base
  end

  def top_link
    nil
  end

  def top_screen_reader_only
    false
  end

  def top_description
    try(:description)
  end
end
