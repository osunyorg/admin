# == Schema Information
#
# Table name: university_person_involvement_localizations
#
#  id            :uuid             not null, primary key
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_language_id_75d7367448                                  (language_id)
#  idx_on_university_id_0b815cf13a                                (university_id)
#  index_university_person_involvement_localizations_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_69c929cdec  (university_id => universities.id)
#  fk_rails_69e7defd73  (language_id => languages.id)
#  fk_rails_ec0c3f2630  (about_id => university_person_involvements.id)
#
class University::Person::Involvement::Localization < ApplicationRecord
  include AsLocalization
  include Sanitizable
  include WithUniversity

  after_commit :sync_with_git

  def sync_with_git
    target_l10n = about.target.localization_for(language)
    return unless target_l10n.present?
    target_l10n.try(:sync_with_git)
  end
end
