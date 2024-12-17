module Communication::Block::Template::Base::WithTop
  extend ActiveSupport::Concern

  def top_title
    block.try(:title)
  end

  def top_description
    try(:description)
  end

  def top_link
    false
  end

  def top_heading
    block.heading_rank_base
  end
end
