# == Schema Information
#
# Table name: communication_block_headings
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  level         :integer          default(1)
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
  belongs_to  :university
  belongs_to  :about,
              polymorphic: true
  belongs_to  :parent, 
              class_name: 'Communication::Block::Heading',
              optional: true
  has_many    :children,
              class_name: 'Communication::Block::Heading',
              foreign_key: :parent_id
  
  scope :root, -> { where(level: 1) }
  default_scope { order(:position) }

  def to_s
    "#{title}"
  end
end
