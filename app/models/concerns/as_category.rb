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

  def references
    descendants +
    category_objects
  end

  def possible_taxonomy?
    persisted? && parent_id.blank?
  end

  def in_taxonomy?
    ancestors.detect { |category| category.is_taxonomy }
  end

  def count_objects_in(language, website)
    objects_in(language, website).count
  end

  # This does not depend on CanCanCan, because no one should edit some categories
  def editable?
    !generated_by_programs?
  end

  protected

  def objects_in(language, website)
    category_objects_direct?  ? direct_objects_in(language)
                              : indirect_objects_in(language, website)
  end

  def category_objects_direct?
    category_object_new.is_direct_object?
  end

  def category_object_new
    category_objects.unscoped.new
  end

  def category_object_polymorphic_name
    category_object_new.class.polymorphic_name
  end

  def direct_objects_in(language)
    descendants_and_self_objects(language)
  end

  # We want only the objects used in the website, not a count of all objects
  def indirect_objects_in(language, website)
    objects = direct_objects_in(language)
    connected_objects = category_objects_in(website)
    intersection = objects & connected_objects
    intersection
  end
  
  def category_objects_in(website)
    website.connections
           .where(indirect_object_type: category_object_polymorphic_name)
           .collect(&:indirect_object)
  end

  def descendants_and_self_objects(language)
    category_objects.unscoped
                    .where(university: university)
                    .for_category(descendants_and_self_ids)
                    .published_now_in(language)
  end

  def descendants_and_self_ids
    @descendants_and_self_ids ||= descendants_and_self.pluck(:id)
  end

  def generated_by_programs?
    # Persons|Organizations|Programs|... categories have no links to programs
    return false unless respond_to?(:is_programs_root)
    # Either taxonomy category (root) or category linked to a program
    is_programs_root == true || program_id.present?
  end

end