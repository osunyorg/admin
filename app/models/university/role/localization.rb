# == Schema Information
#
# Table name: university_role_localizations
#
#  id            :uuid             not null, primary key
#  deleted_at    :datetime
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             uniquely indexed => [language_id], indexed
#  language_id   :uuid             uniquely indexed => [about_id], indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_90a71d885a                (about_id,language_id) UNIQUE
#  index_university_role_localizations_on_about_id       (about_id)
#  index_university_role_localizations_on_language_id    (language_id)
#  index_university_role_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_5533803f3b  (about_id => university_roles.id)
#  fk_rails_922921fab8  (university_id => universities.id)
#  fk_rails_c269f41345  (language_id => languages.id)
#
class University::Role::Localization < ApplicationRecord
  acts_as_paranoid

  include AsLocalization
  include Sanitizable
  include WithUniversity

  def to_s
    "#{description}"
  end

end
