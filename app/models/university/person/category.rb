# == Schema Information
#
# Table name: university_person_categories
#
#  id            :uuid             not null, primary key
#  position      :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_categories_on_parent_id      (parent_id)
#  index_university_person_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_134ac9c0b6  (university_id => universities.id)
#  fk_rails_4c00a79930  (parent_id => university_person_categories.id)
#
class University::Person::Category < ApplicationRecord
  include AsIndirectObject
  include Localizable
  include WithPosition
  include WithTree
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  belongs_to :parent,
             class_name: 'University::Person::Category',
             optional: true
  has_many   :children,
             class_name: 'University::Person::Category',
             foreign_key: :parent_id,
             dependent: :destroy
  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          join_table: :university_people_categories

  def dependencies
    localizations
  end

  def references
    people
  end

end
