module AsCategory
  extend ActiveSupport::Concern

  included do
    include WithPosition
    include WithTree

    belongs_to  :parent,
                class_name: self.name,
                optional: true

    has_many    :children,
                class_name: self.name,
                foreign_key: :parent_id,
                dependent: :destroy

    scope :facets, -> { root.where(facet: true) }
    scope :non_facets, -> { root.where(facet: false) }
  end

  def possible_facet?
    persisted? && parent_id.blank?
  end
end