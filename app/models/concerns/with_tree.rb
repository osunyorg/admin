module WithTree
  extend ActiveSupport::Concern

  included do

    scope :root, -> { where(parent_id: nil) }

    def has_children?
      children.any?
    end

    def has_parent?
      parent_id.present?
    end

    def ancestors
      has_parent? ? parent.ancestors.push(parent)
                  : []
    end

    def self_and_children(level)
      pages = []
      label = "&nbsp;&nbsp;&nbsp;" * level + self.to_s
      pages << { label: label, id: self.id }
      children.each do |child|
        pages.concat(child.self_and_children(level + 1))
      end
      pages
    end

  end


end
