# == Schema Information
#
# Table name: education_cohort_localizations
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
#  index_education_cohort_localizations_on_about_id       (about_id)
#  index_education_cohort_localizations_on_language_id    (language_id)
#  index_education_cohort_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2e862cbf91  (university_id => universities.id)
#  fk_rails_57e968eb32  (about_id => education_cohorts.id)
#  fk_rails_5dc9fc7693  (language_id => languages.id)
#
class Education::Cohort::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include WithUniversity

  delegate  :program, :academic_year,
            to: :about

  def program_l10n
    program.best_localization_for(language)
  end

  def diploma
    program.try(:diploma)
  end

  def diploma_l10n
    diploma&.best_localization_for(language)
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}alumni/#{academic_year.year}/#{program.slug}.html" if for_website?(website)
  end

  def template_static
    "admin/education/cohorts/static"
  end

  # Example: IUT de Bordeaux > Formations > BUT > Génie biologique > Agronomie > 2024
  def hugo_ancestors(website)
    program_l10n.hugo_ancestors_and_self(website)
  end

  def best_breadcrumb_title
    academic_year
  end

  def to_s
    parts = []
    parts << diploma_l10n if diploma_l10n.present?
    parts << program_l10n
    parts << academic_year.year
    parts.join(' — ')
  end
end
