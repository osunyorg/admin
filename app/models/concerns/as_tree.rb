module AsTree
  extend ActiveSupport::Concern

  included do
    scope :root, -> { where(parent_id: nil) }
    scope :ordered_by_position_in_tree, -> { order(:position_in_tree)}

    after_create :update_position_in_tree_later
  end

  def has_children?
    children.any?
  end

  def has_parent?
    parent_id.present?
  end

  def ancestors
    has_parent? ? parent.ancestors.push(parent) : []
  end

  def ancestors_and_self
    ancestors + [self]
  end

  def descendants
    has_children? ? descendants_flattened : []
  end

  def descendants_and_self
    [self] + descendants
  end

  def siblings
    self.class.unscoped
              .where(parent: parent, university: university)
              .where.not(id: id)
              .ordered(original_language)
  end

  def self_and_children(level)
    elements = []
    label = "&nbsp;&nbsp;&nbsp;" * level + self.to_s
    elements << { label: label, id: self.id, parent_id: self.parent_id }
    children.ordered(original_language).each do |child|
      elements.concat(child.self_and_children(level + 1))
    end
    elements
  end

  def update_position_in_tree_later
    return unless respond_to?(:position_in_tree)
    Tree::UpdatePositionJob.set(wait: 1.minute).perform_later(
      university,
      self.class,
      website: try(:website)
    )
  end

  protected

  def original_language
    self.respond_to?(:original_localization) ? original_localization.language : nil
  end

  def descendants_flattened
    children.ordered(original_language).map { |child|
      [child, child.descendants]
    }.flatten
  end

end
