# == Schema Information
#
# Table name: education_diplomas
#
#  id            :uuid             not null, primary key
#  duration      :text
#  ects          :integer
#  level         :integer          default("not_applicable")
#  name          :string
#  short_name    :string
#  slug          :string           indexed
#  summary       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :uuid             indexed
#  original_id   :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_diplomas_on_language_id    (language_id)
#  index_education_diplomas_on_original_id    (original_id)
#  index_education_diplomas_on_slug           (slug)
#  index_education_diplomas_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2ed1656a72  (language_id => languages.id)
#  fk_rails_6cb2e9fa90  (university_id => universities.id)
#  fk_rails_cdb894fcd9  (original_id => education_diplomas.id)
#
class Education::Diploma < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include Localizable
  include WithUniversity

  has_many :programs, dependent: :nullify

  scope :ordered, -> (language = nil) { order(:level) }

  enum level: {
    not_applicable: 0,
    primary: 40,
    secondary: 60,
    high: 80,
    first_year: 100,
    second_year: 200,
    third_year: 300,
    fourth_year: 400,
    master: 500,
    doctor: 800
  }

  def dependencies
    localizations
  end
end
