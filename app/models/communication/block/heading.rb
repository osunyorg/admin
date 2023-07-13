# == Schema Information
#
# Table name: communication_block_headings
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  level         :integer          default(2)
#  position      :integer
#  slug          :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_block_headings_on_about          (about_type,about_id)
#  index_communication_block_headings_on_parent_id      (parent_id)
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

  def references
    [about]
  end

  def duplicate
    heading = self.dup
    heading.save
    heading
  end

  def translate!(about_translation, parent_id = nil)
    translation = self.dup
    translation.about = about_translation
    translation.parent_id = parent_id
    translation.save
    # then translate blocks
    blocks.ordered.each do |block|
      block.translate!(about_translation, translation.id)
    end
    # and then children
    children.ordered.each do |child|
      child.translate!(about_translation, translation.id)
    end
  end

  def to_s
    "#{title}"
  end

  protected

  def last_ordered_element
    about.headings.where(parent_id: self.parent_id).ordered.last
  end

  def compute_level
    self.level = parent ? parent.level + 1
                        : DEFAULT_LEVEL
  end
end
