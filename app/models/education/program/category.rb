# == Schema Information
#
# Table name: education_program_categories
#
#  id            :uuid             not null, primary key
#  bodyclass     :string
#  is_taxonomy   :boolean          default(FALSE)
#  position      :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  index_education_program_categories_on_parent_id      (parent_id)
#  index_education_program_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2f5459d374  (university_id => universities.id)
#  fk_rails_a99207301f  (parent_id => education_program_categories.id)
#
class Education::Program::Category < ApplicationRecord
  include AsCategory
  include AsIndirectObject
  include Localizable
  include WithUniversity

  has_and_belongs_to_many :programs
  alias                   :category_objects :programs

  def dependencies
    [parent] +
    localizations
  end

  def references
    programs
  end
end
