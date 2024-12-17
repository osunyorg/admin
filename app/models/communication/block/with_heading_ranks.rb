module Communication::Block::WithHeadingRanks
  extend ActiveSupport::Concern

  # h1 is the page title
  DEFAULT_HEADING_LEVEL = 2

  # Title is the block intrinsic title
  # Not to be confused with `block_title``
  def heading_self?
    title.present?
  end

  # Self rank is used for the title (h2 if root, h3 if below a title)
  def heading_rank_self
    # No title, no rank self
    return false unless heading_self?
    # Otherwise, rank base
    # Example:
    # - title h2 (root)
    # - title h3 (below a title block)
    heading_rank_base
  end

  def heading_children?
    template.children && template.children.any?
  end

  # Rank children is used for the block's children heading
  def heading_rank_children
    # If a block has no children, then no rank children
    return false unless heading_children?
    # If there's no heading rank self, we take the base rank
    # Example:
    # - No title, children h2 (root)
    # - No title, children h3 (below a title block)
    return heading_rank_base if heading_rank_self == false
    # Otherwise, it's the rank self + 1
    # Example: 
    # - title h2, children h3 (root)
    # - title h3, children h4 (below a title block)
    heading_rank_self + 1
  end

  # If a block is root, it will have level 2
  # If a block is below a title block, it will have level 3
  # Not real yet: if a block is below a subtitle, it will have level 4
  # There are no subtitles at the moment, so it's all between 2 and 3
  def heading_rank_base
    if block_title.present?
      # We delegate the rank computing to the block title, and we add 1
      block_title.heading_rank_self + 1
    else
      # If the about has a block base (Education::Program::Localization), we use it
      # Otherwise, default level (2)
      about.try(:blocks_heading_rank_base) || DEFAULT_HEADING_LEVEL
    end
  end

  protected

  # A block can belong to a title, meaning it is below the title
  def block_title
    return if template_title?
    about.blocks
          .template_title # We are looking for title blocks
          .where('position < ?', position) # Before this block
          .order(position: :desc)
          .limit(1)
          .first
  end
end
