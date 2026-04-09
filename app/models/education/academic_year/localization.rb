# == Schema Information
#
# Table name: education_academic_year_localizations
#
#  id            :uuid             not null, primary key
#  deleted_at    :datetime
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, uniquely indexed => [language_id], indexed
#  language_id   :uuid             not null, uniquely indexed => [about_id], indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_language_id_eb13d82b8d                        (about_id,language_id) UNIQUE
#  index_education_academic_year_localizations_on_about_id       (about_id)
#  index_education_academic_year_localizations_on_language_id    (language_id)
#  index_education_academic_year_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_7f53226466  (about_id => education_academic_years.id)
#  fk_rails_8eb490c1ee  (language_id => languages.id)
#  fk_rails_9de9d01008  (university_id => universities.id)
#
class Education::AcademicYear::Localization < ApplicationRecord
  acts_as_paranoid
  
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include WithUniversity

  alias :academic_year :about

  delegate :year, to: :about

  def git_path_relative
    "academic_years/#{year}/_index.html"
  end

  def template_static
    "admin/education/academic_years/static"
  end

  def to_s
    "#{year}"
  end
end
