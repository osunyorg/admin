# == Schema Information
#
# Table name: communication_block_headings
#
#  id                   :uuid             not null, primary key
#  about_type           :string           not null, indexed => [about_id]
#  level                :integer          default(2)
#  migration_identifier :string
#  position             :integer
#  slug                 :string           indexed
#  title                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  about_id             :uuid             not null, indexed => [about_type]
#  parent_id            :uuid             indexed
#  university_id        :uuid             not null, indexed
#
# Indexes
#
#  index_communication_block_headings_on_about          (about_type,about_id)
#  index_communication_block_headings_on_parent_id      (parent_id)
#  index_communication_block_headings_on_slug           (slug)
#  index_communication_block_headings_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_6d3de8388e  (parent_id => communication_block_headings.id)
#  fk_rails_ae82723550  (university_id => universities.id)
#
class Communication::Block::Heading < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include Sluggable
  include WithPosition
  include WithUniversity

  belongs_to  :university
  belongs_to  :about,
              polymorphic: true
  belongs_to  :parent,
              class_name: 'Communication::Block::Heading',
              optional: true
  has_many    :children,
              class_name: 'Communication::Block::Heading',
              foreign_key: :parent_id,
              dependent: :nullify
  has_many    :blocks,
              dependent: :nullify

  DEFAULT_LEVEL = 2

  scope :root, -> { where(parent_id: nil) }

  before_validation :compute_level
  after_save :touch_about

  def references
    [about]
  end

  def duplicate
    heading = self.dup
    heading.save
    heading
  end

  def localize_for!(new_localization, parent_id = nil)
    localized_heading = self.dup
    localized_heading.about = new_localization
    localized_heading.parent_id = parent_id
    localized_heading.save
    # then translate blocks
    blocks.ordered.each do |block|
      block.localize_for!(new_localization, localized_heading.id)
    end
    # and then children
    children.ordered.each do |child|
      child.localize_for!(new_localization, localized_heading.id)
    end
  end

  def full_text
    to_s
  end

  def to_s
    "#{title}"
  end

  protected

  def set_slug
    self.slug = nil
    super
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(slug: slug, about_type: about_type, about_id: about_id)
              .where.not(id: self.id)
              .exists?
  end

  def last_ordered_element
    about.headings.where(parent_id: self.parent_id).ordered.last
  end

  def compute_level
    self.level = parent ? parent.level + 1
                        : DEFAULT_LEVEL
  end

  def touch_about
    about.touch
  end
end
