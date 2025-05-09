# == Schema Information
#
# Table name: university_person_categories
#
#  id            :uuid             not null, primary key
#  bodyclass     :string
#  is_taxonomy   :boolean          default(FALSE)
#  position      :integer          not null
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

  has_and_belongs_to_many :people
  alias                   :university_people :people
  alias                   :category_objects :people

  def dependencies
    [parent] +
    localizations
  end

  def references
    super +
    people
  end

end
