module Communication::Block::WithHeadingRanks
  extend ActiveSupport::Concern
  
  DEFAULT_HEADING_LEVEL = 2 # h1 is the page title

  included do
    belongs_to :heading, optional: true
  
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

  def set_heading_from_about
    # IMPROVEMENT: Ne gère que le 1er niveau actuellement
    self.heading ||= about.headings.root.ordered.last
  end

  def heading_rank_base
    heading.present?  ? heading.level + 1
                      : DEFAULT_HEADING_LEVEL
  end
end
