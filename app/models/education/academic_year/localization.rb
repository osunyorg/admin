# == Schema Information
#
# Table name: education_academic_year_localizations
#
#  id            :uuid             not null, primary key
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed
#  language_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
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
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include WithUniversity

  def git_path(website)
    "#{git_path_content_prefix(website)}alumni/#{academic_year.year}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/education/academic_years/static"
  end

  def to_s
    "#{about.year}"
  end
end
