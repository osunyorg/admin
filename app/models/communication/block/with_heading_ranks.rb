module Communication::Block::WithHeadingRanks
  extend ActiveSupport::Concern
  
  DEFAULT_HEADING_LEVEL = 2 # h1 is the page title

  included do
    # TODO TITLE remove
    belongs_to :heading, optional: true
  
    # TODO TITLE remove
    before_validation :set_heading_from_about, on: :create
  end

  def heading_rank_self
    template.heading_title.present? ? heading_rank_base
                                    : false
  end

  def heading_rank_children
    return false unless heading_children?
    heading_rank_self ? heading_rank_self + 1
                      : heading_rank_base
  end

  def heading_children?
    template.children && template.children.any?
  end

  protected

  # TODO TITLE remove
  def set_heading_from_about
    # IMPROVEMENT: Ne gère que le 1er niveau actuellement
    self.heading ||= about.headings.root.ordered.last
  end

  def heading_rank_base
    block_title.present? ? block_title.heading_rank_self + 1 : DEFAULT_HEADING_LEVEL
  end

  # A block can belong to a title, meaning it is below the title
  def block_title
    return if title?
    about.blocks
          .template_title # We are looking for title blocks
          .where('position < ?', position) # Before this block
          .order(position: :desc)
          .limit(1)
          .first
  end
end
