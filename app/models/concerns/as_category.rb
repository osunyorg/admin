module AsCategory
  extend ActiveSupport::Concern

  include Orderable
  include WithTree

  included do
    belongs_to  :parent,
                class_name: self.name,
                optional: true

    has_many    :children,
                class_name: self.name,
                foreign_key: :parent_id,
                dependent: :destroy

    scope :taxonomies, -> { root.where(is_taxonomy: true) }
    scope :free, -> { where(is_taxonomy: false) }

    scope :in_taxonomy, -> (category) { where(id: category.descendants.pluck(:id)) }
  end

  def possible_taxonomy?
    persisted? && parent_id.blank?
  end

  def in_taxonomy?
    ancestors.detect { |category| category.is_taxonomy }
  end
end