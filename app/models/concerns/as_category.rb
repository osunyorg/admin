module AsCategory
  extend ActiveSupport::Concern

  include Bodyclassed
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

  def dependencies
    [parent]
  end

  def possible_taxonomy?
    persisted? && parent_id.blank?
  end

  def in_taxonomy?
    ancestors.detect { |category| category.is_taxonomy }
  end
  
  def objects_in(language)
    category_objects.published_now_in(language)
  end

  def count_objects_in(language, website)
    objects = objects_in(language)
    return 0 if objects.none?
    if objects.first.is_indirect_object?
      count_indirect_objects_in(objects, website)
    else
      objects.count
    end
  end

  def editable?
    return true unless respond_to?(:is_programs_root)
    is_programs_root == false && program_id.nil?
  end

  protected

  # We want only the objects used in the website, not a count of all objects
  def count_indirect_objects_in(objects, website)
    type = objects.first.class.polymorphic_name
    connections = website.connections.where(indirect_object_type: type)
    objects_connected = connections.collect(&:indirect_object)
    intersection = objects & objects_connected
    intersection.count
  end
end