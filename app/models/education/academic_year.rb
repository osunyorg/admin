# == Schema Information
#
# Table name: education_academic_years
#
#  id            :uuid             not null, primary key
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_academic_years_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_7d376afe35  (university_id => universities.id)
#
class Education::AcademicYear < ApplicationRecord
  include WithUniversity

  has_many :cohorts, class_name: 'Education::Cohort'

  has_many :people,
           class_name: 'University::Person',
           through: :cohorts

  scope :ordered, -> { order(year: :desc) }

  def cohorts_in_context(context)
    return cohorts if context.nil? || !context.respond_to?(:cohorts)
    cohorts & context.cohorts
  end

  def alumni_in_context(context)
    return alumni if context.nil? || !context.respond_to?(:alumni)
    people & context.alumni
  end

  def to_s
    "#{year}"
  end
end
