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
#  language_id   :uuid             not null, indexed
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
  include Contentful
  include Sanitizable
  include Sluggable
  include WithGitFiles
  include WithPermalink
  include WithUniversity

  has_many :programs, dependent: :nullify

  scope :ordered, -> { order(:level, :name) }

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

  def git_path(website)
    "#{git_path_content_prefix(website)}diplomas/#{slug}/_index.html" if for_website?(website)
  end

  def dependencies
    blocks
  end

  def references
    programs
  end

  def to_s
    "#{name}"
  end
end
