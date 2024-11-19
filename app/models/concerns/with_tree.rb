module WithTree
  extend ActiveSupport::Concern

  included do
    scope :root, -> { where(parent_id: nil) }
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
              .where(
                parent: parent,
                university: university
              )
              .where.not(id: id)
              .ordered(original_localization.language)
  end

  def self_and_children(level)
    elements = []
    label = "&nbsp;&nbsp;&nbsp;" * level + self.to_s
    elements << { label: label, id: self.id, parent_id: self.parent_id }
    children_ordered.each do |child|
      elements.concat(child.self_and_children(level + 1))
    end
    elements
  end
  
  protected

  def children_ordered
    if self.respond_to?(:original_localization)
      children.ordered(original_localization.language)
    else
      children.ordered
    end
  end

  def descendants_flattened
    children_ordered.map { |child| 
      [child, child.descendants]
    }.flatten
  end

end
