# == Schema Information
#
# Table name: administration_academic_year_localizations
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
#  idx_on_about_id_language_id_7962406d05                        (about_id,language_id) UNIQUE
#  idx_on_language_id_a52fb1a1c1                                 (language_id)
#  idx_on_university_id_31eabbc7a7                               (university_id)
#  index_administration_academic_year_localizations_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_7f53226466  (about_id => administration_academic_years.id)
#  fk_rails_8eb490c1ee  (language_id => languages.id)
#  fk_rails_9de9d01008  (university_id => universities.id)
#
class Administration::AcademicYear::Localization < ApplicationRecord
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
    "admin/administration/academic_years/static"
  end

  def to_s
    "#{year}"
  end
end
