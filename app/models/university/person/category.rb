# == Schema Information
#
# Table name: university_person_categories
#
#  id            :uuid             not null, primary key
#  is_taxonomy   :boolean          default(FALSE)
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
  include AsCategory
  include AsIndirectObject
  include Localizable
  include WithUniversity

  has_and_belongs_to_many :university_people,
                          class_name: 'University::Person',
                          join_table: :university_people_categories
  alias                   :people :university_people

  def dependencies
    localizations
  end

  def references
    people
  end

end
