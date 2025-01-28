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
    # Taxons IN a taxonomy have is_taxonomy = false
    scope :free, -> { root.where(is_taxonomy: false) }

    scope :in_taxonomy, -> (taxonomy) { where(id: taxonomy.descendants.pluck(:id)) }
    # All categories that are not taxonomies, nor belongs to a taxonomy
    scope :out_of_taxonomy, -> {
      ids = taxonomies.map { |taxonomy| taxonomy.descendants_and_self.pluck(:id) }
                      .flatten
                      .compact
      where.not(id: ids) }
  end

  def possible_taxonomy?
    persisted? && parent_id.blank?
  end

  def in_taxonomy?
    ancestors.detect { |category| category.is_taxonomy }
  end

  def count_objects_in(language)
    category_objects.published_now_in(language).count
  end
end