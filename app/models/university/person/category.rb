# == Schema Information
#
# Table name: university_person_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_134ac9c0b6  (university_id => universities.id)
#
class University::Person::Category < ApplicationRecord
  include AsIndirectObject
  include Contentful
  include Permalinkable
  include Sluggable
  include WithUniversity

  has_and_belongs_to_many :people,
                          class_name: 'University::Person::Category',
                          join_table: :university_people_categories,
                          foreign_key: :category_id

  validates :name, presence: true

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def dependencies
    contents_dependencies
  end

  def references
    people
  end


end
