module Communication::Block::WithHeadingRanks
  extend ActiveSupport::Concern

  DEFAULT_HEADING_LEVEL = 2 # h1 is the page title

  def heading_rank_self
    title.present?  ? heading_rank_base
                    : false
  end

  def heading_rank_children
    return false unless heading_children?
    heading_rank_self ? heading_rank_self + 1
                      : heading_rank_base
  end

  def heading_children?
    template.respond_to?(:elements) && template.elements.any?
  end

  protected

  def heading_rank_base
    heading.present?  ? heading.level + 1
                      : DEFAULT_HEADING_LEVEL
  end
end
